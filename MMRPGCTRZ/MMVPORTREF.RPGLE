     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Validate portfolio reference')
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  MMVPORTREF - Validate portfolio reference                    *
      *                                                               *
      *  Function:  This module receives a 4-character field and      *
      *             checks that it is a valid portfolio reference.    *
      *                                                               *
      *  Component of: MMVALIDATE - MM validation modules service     *
      *                             program.                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. 190084             Date 16Feb01               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CPB001             Date 02Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CDL006             Date 26Apr99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP050             Date 24Jul98               *
      *                 CAP002  *CREATE    Date 01Aug97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  190084 - Wrong error messages used.                          *
      *  CPB001 - 'Private Banking' Module                            *
      *  CDL006 - Dealing Fiduciary.                                  *
      *  CAP050 - Midas/ToF Interface                                 *
      *  CAP002 - Conversion of MM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
 
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)
 
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
                                                                                CAP050
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CAP050
      ** EXTERNAL DS FOR SAR DETAILS                                            CAP050
 
      ** External data structure for access programs (short)                    CAP050
     D DSFDY         E DS                  EXTNAME(DSFDY)                       CAP050
 
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
 
      ** Message ID
     D MsgID1          S                   LIKE(#MsgID)
 
      ** Warning message ID
     D WMsgID1         S                   LIKE(#MsgID)
 
      ** Portfolio reference
     D DDPTFR          S              4A
 
      ** Error code from AOPLCSR2 (received from caller)
     D ERPLCS          S              7A
 
      ** Portfolio reference (default value, received from AOPLCSR2 via
      ** caller).
     D O#PTFR          S                   LIKE(DDPTFR)
 
      ** Liabilities included indicator (from SDPORTPD)
     D FCLIAB          S              1A
 
      ** Portfolio Management module flag
     D BGPFMG          S              1A
 
      ** Deal type
     D DDTYPE          S              2A
 
      ** Customer OK flag
     D CustOK          S              1A
 
      ** Error in Book Code field (set here and passed back to caller)
     D BookCdeErr      S              1A
 
      ** Ref attached to 9997 (from SDPORTPD)
     D FCR997          S              4A
 
      ** Customer number from SDPLCSPD
     D QBCUST          S              6A
 
      ** Portfolios supported (from SDPORTPD)
     D FCPORS          S              1A
 
      ** Book Code
     D DDBOKC          S              2A
                                                                                CPB001
      ** Private Banking module indicator                                       CPB001
     D BGN4ST          S              1A                                        CPB001
                                                                                CPB001
      ** Private Banking customer indicator                                     CPB001
     D BBPRBA          S              1A                                        CPB001
      ** Customer Number                                                        CPB001
     D BBCUST          S              6A                                        CPB001
                                                                                CDL006
     D CDL006          S              1A   IMPORT                               CDL006
 
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
 
      ** Reset return codes and intrnal flags
     C                   RESET                   ReturnCode
     C                   RESET                   ErrorFound
     C                   RESET                   WarnFound
 
      **  If screen Portfolio Reference is blank, default it from the
      **  value determined from AOPLCSR2 (called before book code
      **  validation).
      *
     C     DDPTFR        IFEQ      *BLANKS
     C     ERPLCS        ANDEQ     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     DDPTFR        OREQ      *BLANKS                                      CPB001
     C     BBPRBA        ANDEQ     'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
      *                                                                         CAP050
      * If Midas/ToF Interface, take first customer portfolio as default        CAP050
     C*****CAP050******* IFNE      'Y'                                   CAP050 CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   ELSE                                                   CAP050
      *                                                                         CAP050
      * Check if customer has a defined portfolio reference                     CAP050
     C                   MOVEL     QBCUST        PNCNUM                         CAP050
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     BBCUST        PNCNUM                         CPB001
     C                   ENDIF                                                  CPB001
     C     PMKEY         SETLL     PMPORTPD                                     CAP050
     C     PNCNUM        READE     PMPORTPD                               65    CAP050
     C     *IN65         IFEQ      '0'                                          CAP050
     C                   MOVEL     PNPTFR        DDPTFR                         CAP050
     C                   ENDIF                                                  CAP050
     C                   ENDIF                                                  CAP050
      *                                                                         CAP050
     C                   ENDIF
     C*
     C** IF 'LIABILITIES INCLUDED' INDICATOR = 'N',
     C** PORTFOLIO REF. MAY NOT BE ENTERED FOR SOME DEAL TYPES
     C*
     C     DDPTFR        IFNE      *BLANKS
     C     FCLIAB        ANDEQ     'N'
     C     BGPFMG        ANDEQ     'Y'
     C*
     C     DDTYPE        IFEQ      'IP'
     C     DDTYPE        OREQ      'DL'
     C     DDTYPE        OREQ      'LN'
     C     DDTYPE        OREQ      'TI'
     C     DDTYPE        OREQ      'CL'
     C     DDTYPE        OREQ      'FL'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'DP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C     DDTYPE        OREQ      'LP'                                         CDL006
     C     CDL006        ANDEQ     'Y'                                          CDL006
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'PMM0007'     MsgID1
     C                   END
     C*
     C                   END
     C*
     C     BGPFMG        IFEQ      'Y'
     C     CustOK        ANDNE     'N'
     C     ErrorFound    ANDEQ     'N'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     CustOK        ANDNE     'N'                                          CPB001
     C     ErrorFound    ANDEQ     'N'                                          CPB001
     C*
      ** Is customer a Portfolio Management Customer,otherwise error.
     C*
      *
      ** Cust. must be a Portfolio Customer if Portfolio ref. entered
      *
     C*****ERPLCS******* IFEQ      'PMA0008'                                    CPB001
     C*****DDPTFR******* ANDNE     *BLANKS                                      CPB001
     C*****ERPLCS******* OREQ      'PMA0009'                                    CPB001
     C*****DDPTFR******* ANDNE     *BLANKS                                      CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     BBPRBA        ANDNE     'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     ERPLCS        ANDNE     *BLANKS                                      CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
                                                                                CPB001
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C     BBPRBA        ANDNE     'Y'                                          CPB001
     C     BGPFMG        ANDNE     'Y'                                          CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
                                                                                CPB001
     C     BGN4ST        ORNE      'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     ERPLCS        ANDNE     *BLANKS                                      CPB001
     C     DDPTFR        ANDNE     *BLANKS                                      CPB001
     C                   EVAL      ErrorFound = 'Y'
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     BGPFMG        ANDNE     'Y'                                          CPB001
     C                   MOVEL     'PMA0017'     MsgID1                         CPB001
     C                   ENDIF                                                  CPB001
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C**********         MOVEL     'PMM0019'     MsgID1                         CPB001        190084
     C                   MOVEL     'PMA0009'     MsgID1                                       190084
     C                   ENDIF                                                  CPB001
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C**********         MOVEL     'PMM0018'     MsgID1                         CPB001        190084
     C                   MOVEL     'PMA0018'     MsgID1                                       190084
     C                   ENDIF                                                  CPB001
     C                   END
     C*
     C**  Portfolio entered but no associated book found in
     C**  SDBOOKPD to default blank book code, error.
     C*
     C     ERPLCS        IFEQ      'PMA0010'
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
     C*
     C**  Book entered but no portfolio reference found to
     C**  default.
     C*
     C     ERPLCS        IFEQ      'PMA0011'
     C     BGN4ST        IFNE      'Y'                                          CPB001
     C                   MOVEL     O#PTFR        DDPTFR
     C                   ENDIF                                                  CPB001
     C                   EVAL      BookCdeErr = 'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   ENDIF
     C*
     C     ERPLCS        IFEQ      *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     Errorfound    ANDNE     'Y'                                          CPB001
     C     BBPRBA        OREQ      'Y'                                          CPB001
     C     BGN4ST        ANDEQ     'Y'                                          CPB001
     C     Errorfound    ANDNE     'Y'                                          CPB001
     C*
     C** Default value
     C*
     C     DDPTFR        IFEQ      *BLANKS
     C     BGN4ST        ANDNE     'Y'                                          CPB001
     C                   MOVE      O#PTFR        DDPTFR
     C                   END
     C*
     C** Portfolio reference must exist for Customer
     C*
     C     DDPTFR        IFNE      FCR997
     C     *BLANKS       OREQ      FCR997                                       CAP050
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   MOVEL     QBCUST        PNCNUM
     C     BGN4ST        IFEQ      'Y'                                          CPB001
     C                   MOVEL     BBCUST        PNCNUM                         CPB001
     C                   ENDIF                                                  CPB001
     C     PMKEY         CHAIN     PMPORTPD                           65
     C*
     C     *IN65         IFEQ      '1'
     C     PNRECI        OREQ      '*'
     C                   EVAL      ErrorFound = 'Y'
     C     FCPORS        IFNE      'B'
     C     BGN4ST        OREQ      'Y'                                          CPB001
     C                   MOVEL     'PMM0001'     MsgID1
     C                   ELSE
     C                   MOVEL     'PMA0013'     MsgID1
     C                   ENDIF
     C                   END
     C*
     C** Warning if selected Portfolio has been flagged for closure
     C*
     C     ErrorFound    IFEQ      'N'
     C     PNDPCL        ANDNE     0
     C                   EVAL      WarnFound    = 'Y'
     C                   MOVEL     'PMM0008'     WMsgID1
     C                   END
     C*
     C                   END
     C*
     C                   END
     C*
     C**  Bank Portfolio supported, book and portfolio reference
     C**  must match in books file.
     C*
     C     ErrorFound    IFEQ      'N'
     C     FCPORS        ANDEQ     'B'
     C     DDBOKC        ANDNE     *BLANKS
     C     DDPTFR        ANDNE     *BLANKS
     C     BGPFMG        ANDEQ     'Y'                                          CPB001
     C     DDPTFR        IFNE      O#PTFR
     C                   EVAL      ErrorFound = 'Y'
     C                   MOVEL     'PMA0012'     MsgID1
     C                   ENDIF
     C                   ENDIF
     C*
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
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *entry        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    MsgID1
     C                   PARM                    WMsgID1
     C                   PARM                    DDPTFR
     C                   PARM                    ERPLCS
     C                   PARM                    O#PTFR
     C                   PARM                    FCLIAB
     C                   PARM                    BGPFMG
     C                   PARM                    DDTYPE
     C                   PARM                    CustOK
     C                   PARM                    BookCdeErr
     C                   PARM                    FCR997
     C                   PARM                    QBCUST
     C                   PARM                    FCPORS
     C                   PARM                    DDBOKC
     C                   PARM                    BGN4ST                         CPB001
     C                   PARM                    BBPRBA                         CPB001
     C                   PARM                    BBCUST                         CPB001
 
      ** Define key for PMPORTPD
     C     PMKEY         KLIST
     C                   KFLD                    PNCNUM
     C                   KFLD                    DDPTFR
      *                                                                         CAP050
      ** Check if Midas/ToF Interface feature is present                        CAP050
     C                   CALLB     'AOSARDR0'                                   CAP050
     C                   PARM      *BLANKS       @RTCD                          CAP050
     C                   PARM      '*VERIFY'     @OPTN                          CAP050
     C                   PARM      'CAP050'      @SARD                          CAP050
     C     SCSARD        PARM      SCSARD        DSFDY                          CAP050
     C     @RTCD         IFEQ      *BLANKS                                      CAP050
     C                   MOVE      'Y'           CAP050            1            CAP050
     C                   ELSE                                                   CAP050
     C                   MOVE      'N'           CAP050                         CAP050
     C                   ENDIF                                                  CAP050
 
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
(c) Misys International Banking Systems Ltd. 2001
