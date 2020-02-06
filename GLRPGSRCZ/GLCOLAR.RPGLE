     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral Allocations retrieval')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLAR   - GL Collateral Allocations retrieve a record      *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG11623           Date 27Jun06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084  *CREATE    Date 20Aug03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG11623 - Sequence No. column should be included (Recompile)*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - Synchronous calling of APIs                         *
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
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      ** Collateral Allocation Screen Format(Current)
     D COLAScnFmt    E DS                  EXTNAME(GLSCLAPD)
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
      ** Collateral Allocation File Format
     D COLAFilFmt    E DS                  EXTNAME(GLCOLAPD)
 
      ** Deal in File Format from the file where original transactions are written to
     D COLLFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D QQSAC1        E                     EXTFLD(QQSACD)                                     CGL029
 
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      ** Override Database Table
     D ##OX1           S              1    DIM(50) CTDATA PERRCD(50)
 
      **--------------------------------------------------------------------------------------------
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D Trnn_In         DS
      ** DS of all key fields read from GLSCLAPD
     D  DDBRCA_IN              1      3
     D  DDCUSN_IN              4     13
     D  DDMODI_IN             14     15
     D  DDFCTY_IN             16     26
     D  DDLNLM_IN             27     32
     D  DDREAC_IN             33     50
     D  DDCREF_IN             51     60
 
      **-----------------------------------------------------------------------
      /EJECT
      ** +--- Start of main processing -----------------------------------+
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDBRCA            3
     C                   PARM                    DDCUSN           10
     C                   PARM                    DDMODI            2
     C                   PARM                    DDFCTY           11
     C                   PARM                    DDLNLM            6
     C**********         PARM                    DDREAC           18                          CGL029
     C                   PARM                    DDREAC           24                          CGL029
     C                   PARM                    DDCREF           10
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
 
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'GLUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,GLCOLA02
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   COLAFilFmt
     C                   CLEAR                   COLLFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      GLCOLARED
      *
      * Use newly retrieved next or last record for the rest of the processing.
     C                   MOVEL     @TRRED        Trnn_In
      *
     C                   MOVEL     DDBRCA_IN     DDBRCA
     C                   MOVEL     DDCUSN_IN     DDCUSN
     C                   MOVEL     DDMODI_IN     DDMODI
     C                   MOVEL     DDFCTY_IN     DDFCTY
     C                   MOVEL     DDLNLM_IN     DDLNLM
     C                   MOVEL     DDREAC_IN     DDREAC
     C                   MOVEL     DDCREF_IN     DDCREF
      *
     C                   ELSE
     C                   MOVEL     DDBRCA        DDBRCA_IN
     C                   MOVEL     DDCUSN        DDCUSN_IN
     C                   MOVEL     DDMODI        DDMODI_IN
     C                   MOVEL     DDFCTY        DDFCTY_IN
     C                   MOVEL     DDLNLM        DDLNLM_IN
     C                   MOVEL     DDREAC        DDREAC_IN
     C                   MOVEL     DDCREF        DDCREF_IN
      *
     C                   MOVEL     Trnn_In       @TRRED
     C                   MOVEL     *BLANK        @ERRMS
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             @TRRED <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   MOVEL     DDACTN        ADACTN
     C                   MOVEL     DDBRCA        ADBRCA
     C                   MOVEL     DDCUSN        ADCUSN
     C                   MOVEL     DDMODI        ADMODI
     C                   MOVEL     DDFCTY        ADFCTY
     C                   MOVEL     DDLNLM        ADLNLM
     C                   MOVEL     DDREAC        ADREAC
     C                   MOVEL     DDCREF        ADCREF
      *
     C                   EXSR      GLCOLARTV
      *
      * Convert to screeen format
     C     Idx           IFEQ      0
      * Access Collateral Details to ge the currency code.
     C                   MOVE      'E'           DDACTN
     C                   EXSR      GLCOLLRTV
      *
     C                   MOVE      CDCCY         PColCur
     C                   EXSR      GLCOLACVT
     C                   MOVE      DDCREF        ADCREF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'ADCUSN'      FldNameArr(1)
     C                   MOVEL     @ERRMS        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   EVAL                    Buffer = COLAScnFmt
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLCOLARED     BEGSR
      *
     C                   CALLB     'GLCOLARED'
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * ACTION CODE
     C                   PARM                    DDACTN            1
      * Transaction reference
     C                   PARM                    DDCREF           10
     C                   PARM                    DDBRCA            3
      * Customer no.
     C                   PARM                    DDCNUM            6
     C                   PARM                    DDMODS            2
     C                   PARM                    DDFCUS            6
     C                   PARM                    DDFTYP            3
     C                   PARM                    DDFSEQ            2
     C                   PARM                    DDLNLM            6
     C                   PARM                    DDSBRC            3
     C                   PARM                    DDSCNM            6
     C                   PARM                    DDSCCY            3
     C**********         PARM                    DDSACD            4                          CGL029
     C                   PARM                    DDSACD           10                          CGL029
     C                   PARM                    DDSSEQ            2
 
      * Read forwards
     C                   PARM                    @RDFWD            1
 
      * Read backwards
     C                   PARM                    @RDBCK            1
 
      * Output Parameters :
      * Error meassage
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Transaction read
     C                   PARM      *BLANK        @TRRED           56
      *
      * Front Office ID READ
     C                   PARM      *BLANK        @FTRED           20
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
     C     GLCOLARTV     BEGSR
 
     C                   RESET                   RetCodeOut
      *
     C                   CALLB     'GLCOLARTV'
      *
      * INPUTS
      ** Return Code
     C                   PARM                    RetCodeIn
      * Mode
     C                   PARM                    P#MODE            1
      * Response mode
     C                   PARM      'S'           RESPMODE          1
 
      * Action and screen fields
     C                   PARM                    ADACTN            1
     C                   PARM                    ADBRCA            3
     C                   PARM                    ADCUSN           10
     C                   PARM                    ADMODI            2
     C                   PARM                    ADFCTY           11
     C                   PARM                    ADLNLM            6
     C**********         PARM                    ADREAC           18                          CGL029
     C                   PARM                    ADREAC           24                          CGL029
     C                   PARM                    ADCREF           10
      *
      * OUTPUTS
      * Assignment Details in file format
     C                   PARM                    COLAFilFmt
 
      * Action and customer OK indicators
     C                   PARM                    S#ACTNok          1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Ix                3 0
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
 
     C     GLCOLLRTV     BEGSR
      *
     C                   CALLB     'GLCOLLRTV'
      ** INPUT PARAMETERS:
      ** Initial screen fields
     C                   PARM                    DDACTN            1
     C                   PARM                    DDCREF           10
     C                   PARM                    DDREVF           10
     C                   PARM      *BLANK        DDREQR            1
     C                   PARM      *BLANK        DDSENT            1
     C                   PARM      *BLANK        DDSCMP            3
     C                   PARM      *BLANK        DDSBRC            3
     C                   PARM      *BLANK        DDSCOL            5
     C                   PARM      *BLANK        DDSCNU           10
     C                   PARM      *BLANK        DDSCCY            3
     C                   PARM      *BLANK        DDSVAL           16
     C                   PARM      *BLANK        DDSGNS            1
      *
     C                   PARM                    CGL012            1
      *
      ** Mode of operation
     C                   PARM      *BLANK        ModeOp            6
      *
      ** Response Mode
     C                   PARM      'S'           RespMode          1
      *
      ** Front Office Id
     C                   PARM                    DDFRTN           20
      *
      ** OUTPUT PARAMETERS:
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM      *BLANKS       FldNameArr
     C                   PARM      *BLANKS       MsgIdArr
     C                   PARM      *BLANKS       MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM      0             Idx
      *
      ** Collateral details (file format)
     C                   PARM      *BLANKS       COLLFilFmt
      *
      ** OK Flags
     C                   PARM      *BLANK        DDACTNOK          1
     C                   PARM      *BLANK        DDCREFOK          1
     C                   PARM      *BLANK        DDREVFOK          1
     C                   PARM      *BLANK        DDREQROK          1
     C                   PARM      *BLANK        DDSENTOK          1
     C                   PARM      *BLANK        DDSCMPOK          1
     C                   PARM      *BLANK        DDSBRCOK          1
     C                   PARM      *BLANK        DDSCOLOK          1
     C                   PARM      *BLANK        DDSCNUOK          1
     C                   PARM      *BLANK        DDSCCYOK          1
     C                   PARM      *BLANK        DDSVALOK          1
     C                   PARM      *BLANK        DDSGNSOK          1
      *
 
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      **********************************************************************
     C     GLCOLACVT     BEGSR
      *
     C                   CALLB     'GLCOLACVT'
 
      * INPUTS
      * Return Code
     C                   PARM      *BLANKS       RetCodeOut
      * (Current) Deal in file format
     C                   PARM                    COLAFilFmt
 
      * OUTPUTS
      * (Current) Deal in screen format
     C                   PARM                    COLAScnfmt
      * Deal Status
     C                   PARM                    PColCur           3
 
     C                   ENDSR
      **********************************************************************
      /EJECT
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** ACCESS BANK DETAILS
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Overrride GLCOLAL0
      *
     C                   Z-ADD     50            MESLEN           15 5
     C                   CALL      'QCMDEXC'
     C                   PARM                    ##OX1
     C                   PARM                    MESLEN
      *                                                                  q
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
** ##OX1
OVRDBF FILE(GLCOLAX0) TOFILE(GLCOLAL0) SHARE(*NO)
