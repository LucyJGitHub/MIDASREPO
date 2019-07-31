     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL JE Item Support Log Setup Module')            *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLBITPLOG - JE Item Support Log Setup Module                 *
      *                                                               *
      *  Function:  This module will convert detail fields of         *
      *             Journal Batch Item in file format to screen fmt   *
      *             to be used in writing records to the log file.    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 CAP207             Date 10Feb11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 BG9185             Date 08Nov05               *
      *                 BUG2948            Date 03Jun04               *
      *                 CRE019             Date 12Jan04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CAP207 - Account Balance Check extended to other APIs        *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BG9185 - Correction to CGL029                                *
      *  BUG2948 - Different branch code item accepted even if        *
      *           multiple branch indicator is set to 'N'. (recompile)*
      *  CRE019 - Cheque Processing and Maintenance (Recompile)       *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *pssr - Error processing                                      *
      * *inzsr - Initialization                                       *
      *                                                               *
      *    The *inzsr subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
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
      **--------------------------------------------------------------+
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------+
 
      **--------------------------------------------------------------+
      **--------------------------------------------------------------+
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
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
 
     D BITPFilFmt    E DS                  EXTNAME(GLJENPPD)
      ** JE Item details in file format
 
     D BITPScnFmt    E DS                  EXTNAME(GLBITPPD)
     D*GLBTACCD******E                     EXTFLD(QQACCD)                             CGL029  BG9185
      ** JE Item details in screen format
 
     D ExtDataDS     E DS                  EXTNAME(GLBPEXPD)
      ** API BITP extra data layout file
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Bank Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Externally described DS for Currency details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - short data structure
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** DS for access programs - long data structure
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Define parameter to be passed to APLOGTRAN.
     D TRANSDTL        S           5800A
 
      ** Define variables used by ZEDIT module
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
 
      ** Define variables used by ZDATE2 module
     D ZDAYNO          S                   LIKE(BJRDNB)
     D ZDATFM          S                   LIKE(BJDFIN)
     D ZDATE           S              6P 0
     D ZADATE          S              7A
 
      ** Define other work parameters and variables
     D PCCY            S                   LIKE(BTCYCD)
     D WAMT            S                   LIKE(ZFIELD)
 
      ** Define parameters for AOSARDR0
     D PRTCD           S              7A
     D POPTN           S              7A
 
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *inzsr  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Execute detail processing
     C                   EXSR      SRPROC
 
 
      ** End of program
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Detail processing                                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: ZEDIT                                                 *
      *         ZDATE2                                                *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
      ** Initialise Transaction Detail and Extension data fields
     C                   CLEAR                   TRANSDTL
     C                   CLEAR                   ExtDataDS
 
      ** Fill the fields of file GLBITPPD with received values
      ** passed by GLBITPUPD
     C                   EVAL      DDCYCD = BTCYCD
     C                   EVAL      DDACCD = BTACCD
     C                   EVAL      DDACSN = BTACSN
     C                   EVAL      DDIBCA = BTIBCA
     C                   EVAL      DDDCIN = BTDCIN
     C                   EVAL      DDTRTY = BTTRTY
     C                   EVAL      DDTSTY = BTTSTY
     C                   EVAL      DDCQNB = BTCQNB
     C                   EVAL      DDSWCR = BTSWCR
     C                   EVAL      DDPRCN = BTPRCN
     C                   EVAL      DDACNB = BTACNB
     C                   EVAL      DDBKCD = BTBKCD
     C                   EVAL      DDRVDI = BTRVDI
     C                   EVAL      DDRINO = BTRINO
     C                   EVAL      DDOCCY = BTOCCY
 
 
      ** Fill Acct identifier field with value from Ret acct no,
      ** Nostro no or Cust no, whichever has a value.
     C                   IF        BTRACN <> *ZEROS
     C                   MOVEL     BTRACN        DDACID
     C                   ELSE
 
     C                   IF        BTNNBI <> *BLANKS
     C                   MOVEL     BTNNBI        DDACID
     C                   ELSE
      ** If the two fields were blank, assume that the third one has
      ** a value
     C                   MOVEL     BTCUST        DDACID
     C                   ENDIF
     C                   ENDIF
 
      ** Fill Narrative fld with value from Narrative code or
      ** Narrative description, whichever is not blank.
     C                   IF        BTNVCD <> *BLANKS
     C                   EVAL      DDNARR = BTNVCD
     C                   ELSE
     C                   EVAL      DDNARR = BTNRDC
     C                   ENDIF
 
      ** Convert unsigned numeric fields into screen format
     C                   MOVE      BTNITM        DDNITM
 
      ** Convert posting amount to screen format
     C                   CLEAR                   WAMT
     C                   EVAL      PCCY = BTCYCD
     C                   MOVE      BTPTAM        WAMT
     C                   EXSR      SRCvtAmt
     C                   MOVE      ZFIELD        DDPTAM
 
      ** Convert original amount field, if there's any.
     C                   IF        BTOCCY <> *BLANKS
 
     C                   CLEAR                   WAMT
     C                   EVAL      PCCY = BTOCCY
     C                   MOVE      BTOAMT        WAMT
     C                   EXSR      SRCvtAmt
     C                   MOVE      ZFIELD        DDOAMT
 
     C                   ENDIF
 
      ** Convert value date to screen format
     C                   CLEAR                   ZDATE
     C                   CLEAR                   ZADATE
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    BTVLDT
     C                   PARM                    ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
 
     C                   MOVE      ZDATE         DDVLDT
 
      ** Set the value of TRANSDTL to be returned to GLBITPUPD module.
      ** This data structure will be used by APLOGTRAN in writing to
      ** the standard API log file.
     C                   EVAL      TRANSDTL = BITPScnFmt + ExtDataDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmt - Subroutine to convert amt to screen format        *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: ZEDIT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRCvtAmt      BEGSR
 
      ** Retrieve number of dec places to use for conversion
      ** via access object
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** If error occurred, perform abnormal termination
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDCURRPD'
     C                   EVAL      DBKey = PCCY
     C                   Z-ADD     002           DBase
     C                   EVAL      RetcodeOut = '*ERROR    '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Proceed with the conversion if no error occurred in AOCURRRO
     C                   EVAL      ZADEC = A6NBDP
     C                   EVAL      ZFIELD = WAMT
 
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly called on program activation            *
      *                                                               *
      * Calls: AOBANKR0 - Bank details                                *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
      ** Input/Output Parameters:
      ** ========================
      ** Return Code
      ** JE Item details in file format
      ** Transaction details
 
     C     *entry        PLIST
     C                   PARM                    RetCodeOut
     C                   PARM                    BITPFilFmt
     C                   PARM                    TRANSDTL
 
      ** Initialise field for error processing
     C                   EVAL      DBPgm = 'GLBITPLOG'
 
      ** Access Bank details via access program
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** If error occurred, perform abnormal termination
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBKey = '*FIRST'
     C                   Z-ADD     001           DBase
     C                   EVAL      RetCodeOut = '*ERROR    '
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Save value of date format indicator for later processing
     C                   MOVE      BJDFIN        ZDATFM
 
      **--------------------------------------------------------------+
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------+
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
