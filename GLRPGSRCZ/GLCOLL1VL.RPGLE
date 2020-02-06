     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral 1st detail screen validation')     *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLL1VL - Collateral First Detail Screen Validation        *
      *                                                               *
      *  Function: This module will perform validation on the first   *
      *            detail screen and return any error conditions or   *
      *            messages to the screen input module.               *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CGL014 - Collaterals Processing                              *
      *           Changed for compiling purposes only; Collateral     *
      *           Details maintenance is redundant in MidasPlus 1.1   *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGL011 - Collateral Processing for Midas (Phase 1)           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Collateral File Definition Details
     D NwCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      *
      ** Collateral File Definition Details
     D CrCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
     D                                     PREFIX(P_)
      *
      ** Collateral Screen Definition Details
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      *
      ** Error indicator for Collateral Details
     D OkCoScnFld    E DS                  EXTNAME(GLECOLPD)
      *
      ** Midas Rundate
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
      *
      ** Midas User Data Area
     D ZMUSER        E DS                  EXTNAME(ZMUSER) DTAARA(ZMUSER)
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Company Details
     D SDCOMP        E DS                  EXTNAME(SDCOMPPD)
      *
      ** Externally described DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
      ** Externally described DS for Collateral Types Details
     D SDCOTP        E DS                  EXTNAME(SDCOTPPD)
      *
      ** Externally described DS for Collateral Locations Details
     D SDCOLO        E DS                  EXTNAME(SDCOLOPD)
      *
      ** Externally described DS for Counterparty Nostro Details
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)
      *
      ** Externally described DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** DS for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** DS for Access Programs
     D DSLDY         E DS                  EXTNAME(DSLDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message IDs
     D Ix              S              3P 0
      *
      ** Index for arrays of warning messages
     D WIx             S              3P 0
      *
      ** Parameters for ZALIGN
     D ZAlignOk        S              1A
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
     D ZADIG           S              2P 0
      *
      ** Parameters for ZDATE1
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D ErrorFlag       S              1A
      *
     D WWSDAT          S                   LIKE(CDSDAT)
     D WWVDAT          S                   LIKE(CDVDAT)
     D WWEDAT          S                   LIKE(CDEDAT)
     D WWRVDT          S                   LIKE(CDRVDT)
     D*WWUNIT***       S                   LIKE(CDUNIT)                                       CGL014
     D WWUNIT          S                   LIKE(CDNAMT)                                       CGL014
     D WWPCNT          S                   LIKE(CDPCNT)
     D*WWUAMT***       S                   LIKE(CDUAMT)                                       CGL014
     D*WWMAMT***       S                   LIKE(CDMAMT)                                       CGL014
     D WWUAMT          S                   LIKE(CDUPRC)                                       CGL014
     D WWMAMT          S                   LIKE(CDMXNA)                                       CGL014
     D WWVAMT          S                   LIKE(CDVAMT)
     D WWVLDT          S                   LIKE(CDVLDT)
     D WWNVDT          S                   LIKE(CDNVDT)
     D WWMARG          S                   LIKE(CDMARG)
     D WWLEND          S                   LIKE(CDLAMT)
      *
      ** Lending Amount Change indicator
     D WLendChg        S              1A   INZ(' ') EXPORT                      CGL011
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      ** Perform detail validation process
     C                   EXSR      SRDETVAL
      *
      ** If no errors, set up outstanding fields for valid file.
     C     IX            IFEQ      0
     C                   EXSR      SRSETUPVLD
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETVAL - Detail Validation processing                      *
      *                                                               *
      *****************************************************************
     C     SRDETVAL      BEGSR
      *
     C                   EXSR      SRENTY
     C                   EXSR      SRCOMP
     C                   EXSR      SRBRCA
     C                   EXSR      SRCTYP
     C                   EXSR      SRCUST
     C                   EXSR      SRSTAT
     C                   MOVEL     'Y'           DDDESCOK
     C                   EXSR      SRGNSP
     C                   MOVEL     'Y'           DDXREFOK
     C                   EXSR      SRSDAT
     C                   EXSR      SRVDAT
     C                   EXSR      SREDAT
     C                   EXSR      SRRNEW
     C                   EXSR      SRRDAT
     C                   EXSR      SRRFREQ
     C                   EXSR      SRRDAY
     C                   EXSR      SRCCY
     C                   EXSR      SRAPIN
     C                   EXSR      SRUNIT
     C                   EXSR      SRPERC
     C                   EXSR      SRUAMT
     C                   EXSR      SRMAMT
     C                   EXSR      SRVALUE
     C                   EXSR      SRVALUER
     C                   EXSR      SRVLDAT
     C                   EXSR      SRNVLDAT
     C                   EXSR      SRNFREQ
     C                   EXSR      SRNDAY
     C                   EXSR      SRMARG
     C                   EXSR      SRHCUST
     C                   EXSR      SRCOLO
     C     DDVAMTOK      IFEQ      'Y'
     C     DDMARGOK      ANDEQ     'Y'
     C                   EXSR      SRCALC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENTY - Entity Validation process                           *
      *                                                               *
      *****************************************************************
     C     SRENTY        BEGSR
      *
     C     DDENTY        IFNE      'K'
     C     DDENTY        ANDNE     'C'
     C     DDENTY        ANDNE     'B'
     C                   MOVEL     'N'           DDENTYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDENTY'      FldNameArr(Ix)
     C                   MOVEL     'COL0027'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDENTYOK      IFEQ      'Y'
     C     DDACTN        ANDEQ     'A'
     C     DDENTY        ANDNE     CDENTY
     C                   MOVEL     'N'           DDENTYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDENTY'      FldNameArr(Ix)
     C                   MOVEL     'COL0028'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOMP - Company Validation process                          *
      *                                                               *
      *****************************************************************
     C     SRCOMP        BEGSR
      *
     C     DDENTYOK      IFEQ      'Y'
     C     DDENTY        ANDNE     'C'
     C     DDCMPY        ANDNE     *Blanks
     C                   MOVEL     'N'           DDCMPYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMPY'      FldNameArr(Ix)
     C                   MOVEL     'COL0029'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDCMPYOK      IFEQ      'Y'
     C     DDENTY        ANDEQ     'C'
      *
     C                   CALL      'AOCOMPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCMPY        PCMPY             3
     C     SDCOMP        PARM      SDCOMP        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCMPYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMPY'      FldNameArr(Ix)
     C                   MOVEL     'COL0030'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     APCMCD        DDCMPY
     C                   ENDIF
      *
     C     RESPMODE      IFEQ      'S'
     C                   CALL      'ZVCOU'
     C                   PARM      DDCMPY        PCMPY
     C                   PARM      *ZERO         ERR               1
      *
     C     ERR           IFEQ      '2'
     C                   MOVE      'N'           DDCMPYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMPY'      FldNameArr(Ix)
     C                   MOVEL     'COL0072'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     ERR           IFEQ      '1'
     C                   MOVE      'N'           DDCMPYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCMPY'      FldNameArr(Ix)
     C                   MOVEL     'COL0073'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRCA - Branch Validation process                           *
      *                                                               *
      *****************************************************************
     C     SRBRCA        BEGSR
      *
     C     DDENTYOK      IFEQ      'Y'
     C     DDENTY        ANDNE     'B'
     C     DDBRCA        ANDNE     *Blanks
     C                   MOVEL     'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'COL0031'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDBRCAOK      IFEQ      'Y'
     C     DDENTY        ANDEQ     'B'
      *
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDBRCA        PBRCD             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'COL0032'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     A8BRCD        DDBRCA
     C                   ENDIF
      *
     C     RESPMODE      IFEQ      'S'
     C                   CALL      'ZVBBU'
     C                   PARM      DDBRCA        PBRCD
     C                   PARM      *ZERO         ERR
      *
     C     ERR           IFEQ      '2'
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'MMA0343'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     ERR           IFEQ      '1'
     C                   MOVE      'N'           DDBRCAOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDBRCA'      FldNameArr(Ix)
     C                   MOVEL     'MMA0344'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCTYP - Collateral Type Validation process                  *
      *                                                               *
      *****************************************************************
     C     SRCTYP        BEGSR
      *
     C                   CALL      'AOCOTPR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCOLT        PCOLT             5
     C     SDCOTP        PARM      SDCOTP        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCOLTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCOLT'      FldNameArr(Ix)
     C                   MOVEL     'COL0033'     MsgIdArr(Ix)
     C                   Z-ADD     0             CTMPCT
     C                   MOVE      ' '           CDCOPT
     C                   ELSE
     C                   MOVE      CTCOLT        DDCOLT
     C     DDACTN        IFEQ      'A'
     C     DDCOLT        ANDNE     CDCOLT
     C     CDCOPT        ANDNE     CTCOPT
     C                   MOVE      'N'           DDCOLTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCOLT'      FldNameArr(Ix)
     C                   MOVEL     'COL0124'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      CTCOPT        CDCOPT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCUST - Collateral Customer Validation process              *
      *                                                               *
      *****************************************************************
     C     SRCUST        BEGSR
      *
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCNUM        PKEY1            10
     C                   PARM      *Blanks       PKYST             7
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           DDCNUMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCNUM'      FldNameArr(Ix)
     C                   MOVEL     'COL0034'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDCNUM
     C                   MOVEL     BBCUST        DDCNUM
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSTAT - Collateral Status Validation process                *
      *                                                               *
      *****************************************************************
     C     SRSTAT        BEGSR
      *
     C     DDSTAT        IFNE      'C'
     C     DDSTAT        ANDNE     'E'
     C     DDSTAT        ANDNE     'I'
     C     DDSTAT        ANDNE     'R'
     C     DDSTAT        ANDNE     'U'
     C                   MOVE      'N'           DDSTATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSTAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0035'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGNSP - General/Specific Indicator Validation process       *
      *                                                               *
      *****************************************************************
     C     SRGNSP        BEGSR
      *
     C     DDGNSP        IFNE      *BLANK
     C     DDGNSP        ANDNE     'G'
     C     DDGNSP        ANDNE     'S'
     C                   MOVE      'N'           DDGNSPOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDGNSP'      FldNameArr(Ix)
     C                   MOVEL     'COL0036'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDGNSP        IFEQ      *BLANK
     C                   MOVE      'S'           DDGNSP
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDAT - Signing Date Validation process                     *
      *                                                               *
      *****************************************************************
     C     SRSDAT        BEGSR
      *
     C     DDSDAT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDSDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0037'     MsgIdArr(Ix)
     C                   ELSE
      *
     C                   MOVEL     DDSDAT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDSDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0038'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWSDAT
     C     WWSDAT        IFGT      BJRDNB
     C                   MOVE      'N'           DDSDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDSDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0039'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDAT - Value Date Validation process                       *
      *                                                               *
      *****************************************************************
     C     SRVDAT        BEGSR
      *
     C     DDVDAT        IFEQ      *BLANKS
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0040'     MsgIdArr(Ix)
     C                   ELSE
      *
     C                   MOVEL     DDVDAT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0041'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWVDAT
     C     WWVDAT        IFLT      WWSDAT
     C                   MOVE      'N'           DDVDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0042'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREDAT - End Date Validation process                         *
      *                                                               *
      *****************************************************************
     C     SREDAT        BEGSR
      *
     C                   Z-ADD     0             WWEDAT
     C     DDEDAT        IFNE      *BLANKS
      *
     C                   MOVEL     DDEDAT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDEDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDEDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0043'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWEDAT
     C     WWEDAT        IFLT      WWVDAT
     C                   MOVE      'N'           DDEDATOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDEDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0044'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRNEW - Renewable Indicator Validation process              *
      *                                                               *
      *****************************************************************
     C     SRRNEW        BEGSR
      *
     C     DDRNEW        IFNE      *BLANK
     C     DDRNEW        ANDNE     'Y'
     C     DDRNEW        ANDNE     'N'
     C                   MOVE      'N'           DDRNEWOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRNEW'      FldNameArr(Ix)
     C                   MOVEL     'COL0045'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDRNEW        IFEQ      *BLANK
     C                   MOVE      'N'           DDRNEW
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDAT - Review Date Validation process                      *
      *                                                               *
      *****************************************************************
     C     SRRDAT        BEGSR
      *
     C                   Z-ADD     0             WWRVDT
      *
     C     DDRVDT        IFNE      *BLANKS
      *
     C                   MOVEL     DDRVDT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDRVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDAT'      FldNameArr(Ix)
     C                   MOVEL     'COL0046'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWRVDT
     C     WWRVDT        IFLT      BJRDNB
     C                   MOVE      'N'           DDRVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRVDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0047'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRFREQ - Review Frequency Validation process                *
      *                                                               *
      *****************************************************************
     C     SRRFREQ       BEGSR
      *
     C     DDRVDT        IFNE      *BLANKS
     C     DDRFRQ        ANDNE     *BLANK
     C     DDRFRQ        ANDNE     'D'
     C     DDRFRQ        ANDNE     'W'
     C     DDRFRQ        ANDNE     'F'
     C     DDRFRQ        ANDNE     'M'
     C     DDRFRQ        ANDNE     'T'
     C     DDRFRQ        ANDNE     'Q'
     C     DDRFRQ        ANDNE     'X'
     C     DDRFRQ        ANDNE     'Y'
     C     DDRVDT        OREQ      *BLANKS
     C     DDRFRQ        ANDNE     *BLANKS
     C                   MOVE      'N'           DDRFRQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRFRQ'      FldNameArr(Ix)
     C                   MOVEL     'COL0048'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRDAY - Review Date Day Number Validation process           *
      *                                                               *
      *****************************************************************
     C     SRRDAY        BEGSR
      *
     C                   MOVE      DDRDNO        WWNUM2            2 0
     C     DDRFRQ        IFNE      'M'
     C     DDRFRQ        ANDNE     'T'
     C     DDRFRQ        ANDNE     'Q'
     C     DDRFRQ        ANDNE     'X'
     C     DDRFRQ        ANDNE     'Y'
     C     DDRDNO        ANDNE     *BLANKS
     C     DDRDNO        ORNE      *BLANKS
     C     WWNUM2        ANDLT     01
     C     DDRDNO        ORNE      *BLANKS
     C     WWNUM2        ANDGT     31
     C                   MOVE      'N'           DDRDNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDRDNO'      FldNameArr(Ix)
     C                   MOVEL     'COL0049'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCY - Collateral Currency Validation process               *
      *                                                               *
      *****************************************************************
     C     SRCCY         BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCCYOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCCY '      FldNameArr(Ix)
     C                   MOVEL     'COL0050'     MsgIdArr(Ix)
     C                   Z-ADD     0             A6NBDP
     C                   ELSE
     C                   MOVEL     A6CYCD        DDCCY
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAPIN - Amount/Percentage Indicator Validation process      *
      *                                                               *
      *****************************************************************
     C     SRAPIN        BEGSR
      *
     C     DDAPCT        IFNE      *BLANK
     C     DDAPCT        ANDNE     'A'
     C     DDAPCT        ANDNE     'P'
     C                   MOVE      'N'           DDAPCTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDAPCT'      FldNameArr(Ix)
     C                   MOVEL     'COL0051'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C     DDAPCT        IFEQ      *BLANK
     C                   MOVE      'A'           DDAPCT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUNIT - Number of Units Validation process                  *
      *                                                               *
      *****************************************************************
     C     SRUNIT        BEGSR
      *
     C                   Z-ADD     0             WWUNIT
      *
     C     DDAPCT        IFEQ      'P'
     C     DDUNIT        ANDNE     *BLANKS
     C                   MOVE      'N'           DDUNITOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDUNIT'      FldNameArr(Ix)
     C                   MOVEL     'COL0052'     MsgIdArr(Ix)
     C                   ELSE
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDUNIT        ZFIELD
     C                   Z-ADD     0             ZADEC
     C                   Z-ADD     13            ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C                   MOVE      'N'           DDUNITOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDUNIT'      FldNameArr(Ix)
     C                   MOVEL     'COL0053'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWUNIT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPERC - Percentage Validation process                       *
      *                                                               *
      *****************************************************************
     C     SRPERC        BEGSR
      *
     C                   Z-ADD     0             WWPCNT
      *
     C     DDAPCT        IFEQ      'A'
     C     DDPCNT        IFNE      *BLANKS
     C                   MOVE      'N'           DDPCNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPCNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0054'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDPCNT        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C     ZFIELD        OREQ      *ZEROS
     C                   MOVE      'N'           DDPCNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPCNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0055'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWPCNT
     C     WWPCNT        IFLT      0
     C     WWPCNT        ORGT      100
     C                   MOVE      'N'           DDPCNTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDPCNT'      FldNameArr(Ix)
     C                   MOVEL     'COL0055'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUAMT - Unit Amount Validation process                      *
      *                                                               *
      *****************************************************************
     C     SRUAMT        BEGSR
      *
     C                   Z-ADD     0             WWUAMT
      *
     C     DDAPCT        IFEQ      'P'
     C     DDUAMT        IFNE      *BLANKS
     C                   MOVE      'N'           DDUAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDUAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0056'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDUAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C     ZFIELD        OREQ      *ZEROS
     C                   MOVE      'N'           DDUAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDUAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0057'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWUAMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMAMT - MAximum Amount Validation process                   *
      *                                                               *
      *****************************************************************
     C     SRMAMT        BEGSR
      *
     C                   Z-ADD     0             WWMAMT
      *
     C     DDAPCT        IFEQ      'A'
     C     DDMAMT        IFNE      *BLANKS
     C                   MOVE      'N'           DDMAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0058'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ELSE
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDMAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C     ZFIELD        OREQ      *ZEROS
     C                   MOVE      'N'           DDMAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0059'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVE      ZFIELD        WWMAMT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALUE - Valuation Validation process                       *
      *                                                               *
      *****************************************************************
     C     SRVALUE       BEGSR
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDVAMT        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C     15            SUB       ZADEC         ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C     ZFIELD        OREQ      *ZEROS
     C                   MOVE      'N'           DDVAMTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVAMT'      FldNameArr(Ix)
     C                   MOVEL     'COL0060'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WWVAMT
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALUER - Valuer Validation process                         *
      *                                                               *
      *****************************************************************
     C     SRVALUER      BEGSR
      *
     C     DDVCNM        IFNE      *BLANKS
      *
     C                   SELECT
     C                   WHEN      %SUBST(DDVCNM:7:4) = *BLANKS
     C                   MOVE      'C'           @VALCUST          1
     C                   WHEN      %SUBST(DDVCNM:9:2) = *BLANKS
     C                   MOVE      'N'           @VALCUST
     C                   OTHER
     C                   MOVE      'C'           @VALCUST
     C                   ENDSL
      *
     C                   IF        %SUBST(DDVCNM:1:1) = '?'
     C                   SELECT
     C                   WHEN      %SUBST(DDVCNM:2:1) = 'N'
     C                   MOVE      'N'           @VALCUST
     C                   WHEN      %SUBST(DDVCNM:2:1) = 'C'
     C                   MOVE      'C'           @VALCUST
     C                   ENDSL
     C                   EVAL      %SUBST(DDVCNM:2:1) = ' '
     C                   ENDIF
      *
     C     @VALCUST      IFEQ      'C'
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDVCNM        PKEY1
     C                   PARM      *Blanks       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        OREQ      'P'
     C                   MOVE      'N'           DDVCNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVCNM'      FldNameArr(Ix)
     C                   MOVEL     'COL0061'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDVCNM
     C                   MOVEL     BBCUST        DDVCNM
     C                   ENDIF
     C                   ENDIF
      *
     C     @VALCUST      IFEQ      'N'
     C                   CALLB     'AOCNSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDVCNM        PCNCD             8
     C     SDCNST        PARM      SDCNST        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDVCNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVCNM'      FldNameArr(Ix)
     C                   MOVEL     'COL0062'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     AWCPNC        DDVCNM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLDAT - Valuation Date Validation process                  *
      *                                                               *
      *****************************************************************
     C     SRVLDAT       BEGSR
      *
     C                   Z-ADD     0             WWVLDT
     C     DDVLDT        IFNE      *BLANKS
      *
     C                   MOVEL     DDVLDT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDVLDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVLDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0063'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWVLDT
     C     WWVLDT        IFGT      BJRDNB
     C                   MOVE      'N'           DDVLDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVLDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0064'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNVLDAT - Next Valuation Date Validation process            *
      *                                                               *
      *****************************************************************
     C     SRNVLDAT      BEGSR
      *
     C                   Z-ADD     0             WWNVDT
      *
     C     DDNVDT        IFNE      *BLANKS
      *
     C                   MOVEL     DDNVDT        DateIn
     C                   EXSR      SRZDATE1
      *
     C     ErrorFlag     IFEQ      'Y'
     C                   MOVE      'N'           DDNVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDNVDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0065'     MsgIdArr(Ix)
     C                   ELSE
     C                   Z-ADD     DAYNOOUT      WWNVDT
     C     WWNVDT        IFLT      BJRDNB
     C                   MOVE      'N'           DDNVDTOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDNVDT'      FldNameArr(Ix)
     C                   MOVEL     'COL0066'     MsgIdArr(Ix)
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNFREQ - Next Valuation Frequency Validation process        *
      *                                                               *
      *****************************************************************
     C     SRNFREQ       BEGSR
      *
     C     DDNVDT        IFNE      *BLANKS
     C     DDVFRQ        ANDNE     *BLANK
     C     DDVFRQ        ANDNE     'D'
     C     DDVFRQ        ANDNE     'W'
     C     DDVFRQ        ANDNE     'F'
     C     DDVFRQ        ANDNE     'M'
     C     DDVFRQ        ANDNE     'T'
     C     DDVFRQ        ANDNE     'Q'
     C     DDVFRQ        ANDNE     'X'
     C     DDVFRQ        ANDNE     'Y'
     C     DDNVDT        OREQ      *BLANKS
     C     DDVFRQ        ANDNE     *BLANKS
     C                   MOVE      'N'           DDVFRQOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVFRQ'      FldNameArr(Ix)
     C                   MOVEL     'COL0067'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNDAY - Next Valuation Date Day Number Validation process   *
      *                                                               *
      *****************************************************************
     C     SRNDAY        BEGSR
      *
     C                   MOVE      DDVDNO        WWNUM2
     C     DDVFRQ        IFNE      'M'
     C     DDVFRQ        ANDNE     'T'
     C     DDVFRQ        ANDNE     'Q'
     C     DDVFRQ        ANDNE     'X'
     C     DDVFRQ        ANDNE     'Y'
     C     DDVDNO        ANDNE     *BLANKS
     C     DDVDNO        ORNE      *BLANKS
     C     WWNUM2        ANDLT     01
     C     DDVDNO        ORNE      *BLANKS
     C     WWNUM2        ANDGT     31
     C                   MOVE      'N'           DDVDNOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDVDNO'      FldNameArr(Ix)
     C                   MOVEL     'COL0068'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMARG - Margin Validation process                           *
      *                                                               *
      *****************************************************************
     C     SRMARG        BEGSR
      *
     C     DDMARG        IFEQ      *BLANKS
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CTMPCT        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDMARG
     C                   ENDIF
      *
     C                   MOVEL     *Blanks       ZFIELD
     C                   MOVEL     DDMARG        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   Z-ADD     3             ZADIG
     C                   EXSR      SRZALIGN
      *
     C     ZALIGNOK      IFNE      'Y'
     C     ZFIELD        OREQ      *ZEROS
     C                   MOVE      'N'           DDMARGOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMARG'      FldNameArr(Ix)
     C                   MOVEL     'COL0069'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WWMARG
     C     WWMARG        IFLT      0
     C     WWMARG        ORGT      100
     C                   MOVE      'N'           DDMARGOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDMARG'      FldNameArr(Ix)
     C                   MOVEL     'COL0069'     MsgIdArr(Ix)
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHCUST - Holding Customer Validation process                *
      *                                                               *
      *****************************************************************
     C     SRHCUST       BEGSR
      *
     C     DDHCNM        IFNE      *BLANKS
     C                   CALLB     'AOCUSTR1'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDHCNM        PKEY1
     C                   PARM      *Blanks       PKYST
     C     SDCUST        PARM      SDCUST        DSLDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     BBPAIN        ANDNE     'P'
     C                   MOVE      'N'           DDHCNMOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDHCNM'      FldNameArr(Ix)
     C                   MOVEL     'COL0070'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     *BLANKS       DDHCNM
     C                   MOVEL     BBCUST        DDHCNM
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLO - Collateral Location Validation process              *
      *                                                               *
      *****************************************************************
     C     SRCOLO        BEGSR
      *
     C     DDCOLO        IFNE      *BLANKS
     C                   CALL      'AOCOLOR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      DDCOLO        PCOLO             3
     C     SDCOLO        PARM      SDCOLO        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'N'           DDCOLOOK
     C                   ADD       1             Ix
     C                   MOVEL     'DDCOLO'      FldNameArr(Ix)
     C                   MOVEL     'COL0071'     MsgIdArr(Ix)
     C                   ELSE
     C                   MOVEL     CLCOLO        DDCOLO
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALC - Lending Value Calculation process                   *
      *                                                               *
      *****************************************************************
     C     SRCALC        BEGSR
      *
     C                   Z-ADD     WWVAMT        WWLEND
     C                   EVAL  (H) WWLEND = WWLEND * (WWMARG/100)
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      WWLEND        ZFIELD
     C                   Z-ADD     A6NBDP        ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDLAMT
      *
     C                   MOVE      *Blank        WLendChg
     C     DDACTN        IFEQ      'A'
     C     P_CDLAMT      ANDNE     WWLEND
     C     DDGNSP        ANDEQ     'G'
     C                   MOVE      'Y'           WLendChg
     C                   ADD       1             WIx
     C                   EVAL      WFldNamArr(WIx) = '*ANY   '
     C                   EVAL      WMsgIdArr(WIx)  = 'COL0127'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZALIGN - Validate/Right allign numeric field               *
      *                                                               *
      *****************************************************************
     C     SRZALIGN      BEGSR
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      'Y'           ZAlignOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDATE1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SRZDATE1      BEGSR
      *
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZEDIT - Edit Unsigned Amount for Screen Output             *
      *                                                               *
      *****************************************************************
     C     SRZEDIT       BEGSR
      *
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSETUPVLD - Set up validated fields for the valid file.     *
      *                                                               *
      *****************************************************************
     C     SRSETUPVLD    BEGSR
      *
     C                   MOVEL     DDENTY        CDENTY
     C                   MOVEL     DDCMPY        CDCMPY
     C                   MOVEL     DDBRCA        CDBRCA
     C                   MOVEL     DDCOLT        CDCOLT
     C                   MOVEL     DDCNUM        CDCNUM
     C                   MOVEL     DDSTAT        CDSTAT
     C                   MOVEL     DDDESC        CDDESC
     C                   MOVEL     DDGNSP        CDGNSP
     C                   MOVEL     DDXREF        CDXREF
     C                   Z-ADD     WWSDAT        CDSDAT
     C                   Z-ADD     WWVDAT        CDVDAT
     C     DDEDAT        IFNE      *BLANKS
     C                   Z-ADD     WWEDAT        CDEDAT
     C                   ENDIF
     C                   MOVEL     DDRNEW        CDRNEW
     C     DDRVDT        IFNE      *BLANKS
     C                   Z-ADD     WWRVDT        CDRVDT
     C                   ENDIF
     C                   MOVEL     DDRFRQ        CDRFRQ
     C     DDRDNO        IFNE      *BLANKS
     C                   MOVEL     DDRDNO        CDRDNO
     C                   ENDIF
     C                   MOVEL     DDCCY         CDCCY
     C                   MOVEL     DDAPCT        CDAPCT
     C     DDUNIT        IFNE      *BLANKS
     C**********         Z-ADD     WWUNIT        CDUNIT                                       CGL014
     C                   Z-ADD     WWUNIT        CDNAMT                                       CGL014
     C                   ENDIF
     C     DDPCNT        IFNE      *BLANKS
     C                   Z-ADD     WWPCNT        CDPCNT
     C                   ENDIF
     C     DDUAMT        IFNE      *BLANKS
     C**********         Z-ADD     WWUAMT        CDUAMT                                       CGL014
     C                   Z-ADD     WWUAMT        CDUPRC                                       CGL014
     C                   ENDIF
     C     DDMAMT        IFNE      *BLANKS
     C**********         Z-ADD     WWMAMT        CDMAMT                                       CGL014
     C                   Z-ADD     WWMAMT        CDMXNA                                       CGL014
     C                   ENDIF
     C     DDVAMT        IFNE      *BLANKS
     C                   Z-ADD     WWVAMT        CDVAMT
     C                   ENDIF
      *
     C     @VALCUST      IFEQ      'C'
     C                   MOVEL     DDVCNM        CDVCNM
     C                   MOVEL     *BLANKS       CDVNST
     C                   ELSE
     C                   MOVEL     DDVCNM        CDVNST
     C**********         Z-ADD     0             CDVCNM                                       CSD027
     C                   MOVE      *BLANKS       CDVCNM                                       CSD027
     C                   ENDIF
      *
     C     DDVLDT        IFNE      *BLANKS
     C                   Z-ADD     WWVLDT        CDVLDT
     C                   ENDIF
     C     DDNVDT        IFNE      *BLANKS
     C                   Z-ADD     WWNVDT        CDNVDT
     C                   ENDIF
     C                   MOVEL     DDVFRQ        CDVFRQ
     C     DDVDNO        IFNE      *BLANKS
     C                   MOVEL     DDVDNO        CDVDNO
     C                   ENDIF
     C     DDMARG        IFNE      *BLANKS
     C                   Z-ADD     WWMARG        CDMARG
     C                   ENDIF
     C     DDHCNM        IFNE      *BLANKS
     C                   MOVEL     DDHCNM        CDHCNM
     C                   ENDIF
     C                   MOVEL     DDCOLO        CDCOLO
     C     DDLAMT        IFNE      *BLANKS
     C                   Z-ADD     WWLEND        CDLAMT
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** Transaction Screen Format
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Mode of Operation
     C                   PARM                    RespMode          1
      *
      ** New Collateral Record
     C                   PARM                    NwCoFilFmt
      *
      ** Old Collateral Record
     C                   PARM                    CrCoFilFmt
      *
      ** Fields OK indicators
     C                   PARM                    OKCoScnFld
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    Ix
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIx
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLL1VAL ' DBPGM
     C                   OUT       LDA
      *
      ** Lock in data area, RUNDAT, to determine the multi-branching ind.
      *
     C     *LOCK         IN        RUNDAT
     C                   UNLOCK    RUNDAT
      *
      ** Lock in data area, ZMUSER, to determine the default branch.
      *
     C     *LOCK         IN        ZMUSER
     C                   UNLOCK    ZMUSER
      *
      ** Access Bank details.
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
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
      *
**  CPY@
(c) Finastra International Limited 2001
