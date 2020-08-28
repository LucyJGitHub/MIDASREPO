     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Validate base-rate code')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Standard routines                                    *
      *                                                               *
      *  ZAVBRATCDE - Validate base-rate code                         *
      *                                                               *
      *  Function:  This module validates a field containing a        *
      *             putative base-rate code.                          *
      *                                                               *
      *  Component of: ZA_ALL - All ZA modules service program        *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 AR755195           Date 13Dec13               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 249905             Date 29Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 16May01               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  AR755195 - Get base rate from SDBSHSPD when transaction is   *
      *             back valued. (Child: AR755196)                    *
      *           - Applied for MD024110                              *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  249905 - When CDL019 is ON, base rate changes should not be  *
      *           allowed for fixed term deals.                       *
      *  CSD006 - Market Data Feed                                    *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for Access Objects - long data structure                                    CSD006
     D DSSDY         E DS                  EXTNAME(DSSDY)                               CSD006
 
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)                                AR755195
      ** External DS for Historic Base Rate details                                         AR755195
                                                                                            AR755195
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** ==========
      ** Parameters
 
      ** First message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Numeric base rate
     D @RATE           S                   LIKE(BACBSR)
 
      ** DRS Base rate code
     D IKDBSR          S                   LIKE(BABSRS)
 
      ** Base rate code
     D DDBSRC          S              2A
 
      ** Deal Currency OK flag
     D CurrOK          S              1A
 
      ** Deal value date
     D @VDYNO          S                   LIKE(BAVDNR)
 
      ** Value date OK flag
     D ValDateOK       S              1A
 
      ** Base rate code facility indicator
     D BLBRCF          S              1A
 
      ** Deal currency
     D DDCCY           S                   LIKE(BACYCD)
 
      ** End of parameters
      ** =================
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
 
     C*
     C**  If the base rate code facility indicator is not 'Y', and the
     C**  base rate code is non-blank, it is an error.
     C     BLBRCF        IFNE      'Y'
     C     DDBSRC        ANDNE     *BLANKS
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0416'     MsgID1
     C                   END
     C*
     C**  If the base rate code, deal currency and deal value date are
     C**  all valid and non-blank, further validate the base rate code.
     C*
 
     C                   IF            ErrorFound = 'N' AND CurrOK <> 'N'
     C                             AND ValDateOK <> 'N' AND DDBSRC <> *blank
     C*
     C**  Access the base rates file to ascertain whether the base rate
     C**  code is valid.
     C                   CALLB     'AOBSRTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      DDCCY         @AJCD             3
     C                   PARM      DDBSRC        @DWND             2
     C*****SDBSRT        PARM      SDBSRT        DSFDY                                  CSD006
     C     SDBSRT        PARM      SDBSRT        DSSDY                                  CSD006
     C*
     C**  If no valid record is found, it is an error.
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'MMM0417'     MsgID1
     C*
     C**  If a valid record has been found, find the base rate to use.
     C                   ELSE
     C                   MOVEL     BABSRC        DDBSRC
      *                                                                                     AR755195
     C     @VDYNO        IFGE      BAVDRC                                                   AR755195
     C     @VDYNO        ORGE      BAVDNR                                                   AR755195
     C*
     C**  If the deal value date is less than value date of new rate
     C**  change, use the previous base rate.
     C     @VDYNO        IFLT      BAVDNR
     C                   Z-ADD     BACBSR        @RATE
     C*
     C** Display a warning message if the user is in Insert mode
     C*
 
     C                   IF        ActionCode = 'I'                                           249905
     C                   EVAL      WarnFound = 'Y'
     C                   MOVEL     'MMM1045'     WMsgID1
     C                   ENDIF                                                                249905
 
     C*
     C**  If the deal value date is greater than value date of new rate
     C**  change, use the next base rate.
     C                   ELSE
     C                   Z-ADD     BANBRT        @RATE
     C                   END
                                                                                            AR755195
      ** Access Historic Base Rates                                                         AR755195
                                                                                            AR755195
     C                   ELSE                                                               AR755195
     C                   Z-ADD     0             @RATE                                      AR755195
     C                   MOVE      DDBSRC        @RATE                                      AR755195
                                                                                            AR755195
     C                   CALL      'AOBSHSR0'                                               AR755195
     C                   PARM      *BLANKS       @RTCD                                      AR755195
     C                   PARM      '*KEY   '     @OPTN                                      AR755195
     C                   PARM      DDCCY         @AJCD                                      AR755195
     C                   PARM      DDBSRC        @DWND                                      AR755195
     C                   PARM      @VDYNO        @HISTDATE         5 0                      AR755195
     C     SDBSHS        PARM      SDBSHS        DSFDY                                      AR755195
                                                                                            AR755195
     C     @RTCD         IFEQ      *BLANKS                                                  AR755195
                                                                                            AR755195
     C     BAVDNR        IFGE      G0HIDT                                                   AR755195
     C     BAVDNR        ANDLE     @VDYNO                                                   AR755195
     C                   Z-ADD     BANBRT        @RATE                                      AR755195
     C                   ELSE                                                               AR755195
     C                   Z-ADD     G0CBSR        @RATE                                      AR755195
     C                   ENDIF                                                              AR755195
                                                                                            AR755195
      ** Get current base rate if not found on Base Rate History file                       AR755195
                                                                                            AR755195
     C                   ELSE                                                               AR755195
                                                                                            AR755195
     C     @VDYNO        IFLT      BAVDNR                                                   AR755195
     C                   Z-ADD     BACBSR        @RATE                                      AR755195
     C                   ELSE                                                               AR755195
     C                   Z-ADD     BANBRT        @RATE                                      AR755195
     C                   ENDIF                                                              AR755195
                                                                                            AR755195
     C                   ENDIF                                                              AR755195
     C                   ENDIF                                                              AR755195
                                                                                            AR755195
     C                   END
     C                   END
     C*
     C**  If the base rate code is valid, set up the DRS base rate code
     C**  on the Standard Deal format.
     C*
     C                   IF        ErrorFound = 'N'
     C     DDBSRC        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       IKDBSR
     C                   ELSE
     C                   MOVE      BABSRS        IKDBSR
     C                   END
     C                   END
 
      ** Return code set in /COPY
     C/COPY ZACPYSRC,SETRETCDE
 
     C                   RETURN
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
      ** Incoming return code (10A)
     C                   PARM                    ReturnCode
      ** First message ID (10A)
     C                   PARM                    MsgID1
      ** Warning message ID (10A)
     C                   PARM                    WMsgID1
      ** Base rate (11,7P, returned by this module)
     C                   PARM                    @RATE
      ** DRS Base rate code (5A, returned by this module)
     C                   PARM                    IKDBSR
      ** Base rate code (2A, from transaction)
     C                   PARM                    DDBSRC
      ** Currency OK flag (1A, from caller)
     C                   PARM                    CurrOK
      ** Deal value date in Midas day number format (5,0P, from caller)
     C                   PARM                    @VDYNO
      ** Value date OK flag (1A, from caller)
     C                   PARM                    ValDateOK
      ** Base rate code facility indicator (1A, from SDTRADPD)
     C                   PARM                    BLBRCF
      ** Deal currency (3A, from transaction)
     C                   PARM                    DDCCY
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C     InzEnd        ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
