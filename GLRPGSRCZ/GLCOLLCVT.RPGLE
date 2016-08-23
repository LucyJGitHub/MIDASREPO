     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas GL Collateral details convert')                  *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GLCOLLCVT - Collateral Details Convert                       *
      *                                                               *
      *  Function: This module will convert all the detail fields     *
      *            of a Collateral item from the format held on       *
      *            file to a screen format.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CGL072             Date 10Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG11415           Date 29May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CGL011  *CREATE    Date 20Sep99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CGL072 - Allow GL Accounts in Collateral                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG11415 - Incorrect display of providers on screen          *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
      *
      ** Collateral File Definition Details
     D CrCoFilFmt    E DS                  EXTNAME(GLCOLLPD)
      ** Array for Provider Customer in file
     D**CDPROV******         265    336  0 dim(12)                                            CSD027
     D**CDPROV******         266    336    dim(12)                                   CSD027 BUG11415
     D  CDPROV               266    337    dim(12)                                          BUG11415
      *
      ** Collateral Screen Definition Details
     D NwCoScnFmt    E DS                  EXTNAME(GLSCOLPD)
      *
      ** Initial screen fields
     D  NwCoScnInt             1     64
      ** First screen fields
     D  NwCoScn1st            65    306
      ** Second screen fields
     D**NwCoScn2nd           307    654                                                       CGL029
     D  NwCoScn2nd           307    666                                                       CGL029
      ** Array for Provider Customer in screen
     D  DDPROV               307    426    dim(12)
      ** Third screen fields
     D**NwCoScn3rd           655    740                                                       CGL029
     D  NwCoScn3rd           667    752                                                       CGL029
      *
      ** Externally described DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for SAR Details                                            CGL072
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                CGL072
      *                                                                                     CGL072
      ** DS for Access Programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for Access Programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Parameters for ZEDIT
     D ZFIELD          S             16A
     D ZADEC           S              1P 0
      *
      ** Parameters for ZDATE2
     D ZDAYNO          S              5P 0
     D ZDATE           S              6P 0
     D ZADATE          S              7A
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
      ** Perform initialisation processing
     C                   EXSR      SRINIT
      *
      ** Perform screen field setting process
     C                   EXSR      SRSCREEN
      *
      ** Perform collateral status setting process
     C                   EXSR      SRCOLLSTS
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation processing                           *
      *                                                               *
      *****************************************************************
     C     SRINIT        BEGSR
      *
     C                   CLEAR                   NwCoScn1st
     C                   CLEAR                   NwCoScn2nd
     C                   CLEAR                   NwCoScn3rd
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCOLLSTS - Set Collateral Status process                    *
      *                                                               *
      *****************************************************************
     C     SRCOLLSTS     BEGSR
      *
     C     CGL012        IFEQ      'N'
     C     CDRECI        ANDEQ     'R'
     C                   MOVEL     'DELETED'     DDSDES
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSCREEN - Set Screen Fields processing                      *
      *                                                               *
      *****************************************************************
     C     SRSCREEN      BEGSR
      *
     C                   EXSR      SRCURRDET
      *
      ** Set display file fields to the corresponding values from  the
      ** old Collateral record.
     C                   MOVEL     CDCREF        DDCREF
     C                   MOVEL     CDENTY        DDENTY
     C                   MOVEL     CDCMPY        DDCMPY
     C                   MOVEL     CDBRCA        DDBRCA
     C                   MOVEL     CDCOLT        DDCOLT
     C                   MOVEL     CDCNUM        DDCNUM
     C                   MOVEL     CDSTAT        DDSTAT
      *
     C                   MOVEL     *BLANKS       DDSDES
     C                   SELECT
     C     DDSTAT        WHENEQ    'C'
     C                   MOVEL     'COM'         DDSDES
     C     DDSTAT        WHENEQ    'E'
     C                   MOVEL     'EXP'         DDSDES
     C     DDSTAT        WHENEQ    'I'
     C                   MOVEL     'INC'         DDSDES
     C     DDSTAT        WHENEQ    'R'
     C                   MOVEL     'REQ'         DDSDES
     C     DDSTAT        WHENEQ    'U'
     C                   MOVEL     'REV'         DDSDES
     C                   ENDSL
      *
     C                   MOVEL     CDDESC        DDDESC
     C                   MOVEL     CDGNSP        DDGNSP
     C                   MOVEL     CDXREF        DDXREF
     C                   MOVEL     CDRNEW        DDRNEW
     C                   MOVEL     CDRFRQ        DDRFRQ
     C                   MOVEL     CDCCY         DDCCY
     C                   MOVEL     CDAPCT        DDAPCT
     C                   MOVEL     CDVFRQ        DDVFRQ
     C                   MOVEL     CDCOLO        DDCOLO
     C*****CDPR01        IFNE      0                                                          CSD027
     C     CDPR01        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDPR01        DDPR01
     C                   ENDIF
     C                   MOVEL     CDPFLK        DDPFLK
     C                   MOVEL     CDMODS        DDMODS
     C                   MOVEL     CDINEX        DDINEX
     C                   MOVEL     CDIRF1        DDIRF1
     C                   MOVEL     CDIRF2        DDIRF2
     C                   MOVEL     CDIRF3        DDIRF3
     C                   MOVEL     CDIRF4        DDIRF4
     C                   MOVEL     CDIRF5        DDIRF5
     C                   MOVEL     CDIRF6        DDIRF6
     C                   MOVEL     CDDORF        DDDORF
     C                   MOVEL     CDIPLY        DDIPLY
     C                   MOVEL     CDIPLO        DDIPLO
     C                   MOVEL     CDIRST        DDIRST
     C                   MOVEL     CDINFQ        DDINFQ
     C                   MOVEL     CDRGTR        DDRGTR
      *
     C                   Z-ADD     CDSDAT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDSDAT
      *
     C                   Z-ADD     CDVDAT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDVDAT
      *
     C     CDEDAT        IFNE      *ZERO
     C                   Z-ADD     CDEDAT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDEDAT
     C                   ENDIF
      *
     C     CDRVDT        IFNE      *ZERO
     C                   Z-ADD     CDRVDT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDRVDT
     C                   ENDIF
      *
     C     CDRDNO        IFNE      *ZERO
     C                   MOVEL     CDRDNO        DDRDNO
     C                   ENDIF
      *
     C     CDAPCT        IFEQ      'A'
     C*****CDUNIT        ANDNE     *ZERO                                                      CGL014
     C     CDNAMT        ANDNE     *ZERO                                                      CGL014
     C                   MOVEL     *BLANKS       ZFIELD
     C**********         MOVE      CDUNIT        ZFIELD                                       CGL014
     C                   MOVE      CDNAMT        ZFIELD                                       CGL014
     C                   Z-ADD     0             ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDUNIT
     C                   ENDIF
      *
     C     CDAPCT        IFEQ      'P'
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDPCNT        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDPCNT
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZADEC
      *
     C     CDAPCT        IFEQ      'A'
     C*****CDUAMT        ANDNE     *ZERO                                                      CGL014
     C     CDUPRC        ANDNE     *ZERO                                                      CGL014
     C                   MOVEL     *BLANKS       ZFIELD
     C**********         MOVE      CDUAMT        ZFIELD                                       CGL014
     C                   MOVE      CDUPRC        ZFIELD                                       CGL014
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDUAMT
     C                   ENDIF
      *
     C     CDAPCT        IFEQ      'P'
     C*****CDMAMT        ANDNE     *ZERO                                                      CGL014
     C     CDMXNA        ANDNE     *ZERO                                                      CGL014
     C                   MOVEL     *BLANKS       ZFIELD
     C**********         MOVE      CDMAMT        ZFIELD                                       CGL014
     C                   MOVE      CDMXNA        ZFIELD                                       CGL014
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDMAMT
     C                   ENDIF
      *
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDVAMT        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDVAMT
      *
     C     CDVNST        IFEQ      *BLANKS
     C*****CDVCNM        IFNE      *ZERO                                                      CSD027
     C     CDVCNM        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDVCNM        DDVCNM
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     CDVNST        DDVCNM
     C                   ENDIF
      *
     C     CDVLDT        IFNE      *ZERO
     C                   Z-ADD     CDVLDT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDVLDT
     C                   ENDIF
      *
     C     CDNVDT        IFNE      *ZERO
     C                   Z-ADD     CDNVDT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDNVDT
     C                   ENDIF
      *
     C     CDVDNO        IFNE      *ZERO
     C                   MOVEL     CDVDNO        DDVDNO
     C                   ENDIF
      *
     C     CDMARG        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDMARG        ZFIELD
     C                   Z-ADD     2             ZADEC
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDMARG
     C                   ENDIF
      *
     C*****CDHCNM        IFNE      *ZERO                                                      CSD027
     C     CDHCNM        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDHCNM        DDHCNM
     C                   ENDIF
      *
     C                   Z-ADD     A6NBDP        ZADEC
      *
     C     CDLAMT        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDLAMT        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDLAMT
     C                   ENDIF
      *
     C                   Z-ADD     2             Px                2 0
     C     Px            DOWLE     12
     C*****CDPROV(Px)    IFNE      *Zero                                                      CSD027
     C     CDPROV(Px)    IFNE      *Blanks                                                    CSD027
     C                   MOVEL     CDPROV(Px)    DDPROV(Px)
     C                   ENDIF
     C                   ADD       1             Px
     C                   ENDDO
      *
     C     CDACCR        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDACCR        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDACCR
     C                   ENDIF
      *
     C     CDIAMT        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDIAMT        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDIAMT
     C                   ENDIF
      *
     C*****CDFCUS        IFNE      *ZERO                                                      CSD027
     C     CDFCUS        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDFCUS        DDFCUS
     C                   MOVEL     CDFTYP        DDFTYP
     C                   MOVEL     CDFSEQ        DDFSEQ
     C                   ENDIF
      *
     C*****CDLNLM        IFNE      *ZERO                                                      CLE148
     C                   MOVEL     CDLNLM        DDLNLM
     C**********         ENDIF                                                                CLE148
      *
     C     CDMODS        IFEQ      'RE'
     C/COPY WNCPYSRC,GLCOLLNC01
     C     CDMODS        OREQ      'GL'                                                       CGL072
     C     CGL072        ANDEQ     'Y'                                                        CGL072
     C     CDSACN        IFNE      *ZERO
     C                   MOVEL     CDSACN        DDACNT
     C                   ELSE
     C                   MOVEL     CDSCNM        WWNUM6            6
     C**********         MOVEL     CDSACD        WWNUM4            4                          CGL029
     C                   MOVEL     CDSACD        WWNUM10          10                          CGL029
     C                   MOVEL     CDSSEQ        WWNUM2            2
     C                   EVAL      DDACNT = CDSBRC + WWNUM6 + CDSCCY
     C**********                          + WWNUM4 + WWNUM2                                   CGL029
     C                                    + WWNUM10 + WWNUM2                                  CGL029
     C                   ENDIF
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'A'
     C     CDCACN        IFNE      *ZERO
     C                   MOVEL     CDCACN        DDCTRN
     C                   ELSE
     C                   MOVEL     CDCCNM        WWNUM6
     C**********         MOVEL     CDCACD        WWNUM4                                       CGL029
     C                   MOVEL     CDCACD        WWNUM10                                      CGL029
     C                   MOVEL     CDCSEQ        WWNUM2
     C                   EVAL      DDCTRN = CDCBRC + WWNUM6 + CDCCCY
     C**********                          + WWNUM4 + WWNUM2                                   CGL029
     C                                    + WWNUM10 + WWNUM2                                  CGL029
     C                   ENDIF
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'D'
     C                   MOVEL     CDDEAL        DDCTRN
     C                   ENDIF
      *
     C     CDCOPT        IFEQ      'P'
     C                   MOVEL     CDCSCN        WWNUM6
     C                   EVAL      DDCTRN = CDCSBR + CDCSEC + WWNUM6
     C                   ENDIF
      *
     C*****CDINSR        IFNE      *ZERO                                                      CSD027
     C     CDINSR        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDINSR        DDINSR
     C                   ENDIF
      *
     C     CDIVAL        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDIVAL        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDIVAL
     C                   ENDIF
      *
     C     CDINDT        IFNE      *ZERO
     C                   Z-ADD     CDINDT        ZDAYNO
     C                   EXSR      SRZDATE2
     C                   MOVEL     ZDATE         DDINDT
     C                   ENDIF
      *
     C     CDINDN        IFNE      *ZERO
     C                   MOVEL     CDINDN        DDINDN
     C                   ENDIF
      *
     C     CDVPCH        IFNE      *ZERO
     C                   MOVEL     *BLANKS       ZFIELD
     C                   MOVE      CDVPCH        ZFIELD
     C                   EXSR      SRZEDIT
     C                   MOVE      ZFIELD        DDVPCH
     C                   ENDIF
      *
     C     CDSCNS        IFEQ      *BLANKS
     C*****CDSCHC        IFNE      *ZERO                                                      CSD027
     C     CDSCHC        IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     CDSCHC        DDSCHC
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     CDSCNS        DDSCHC
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURRDET - Access Currency Details                          *
      *                                                               *
      *****************************************************************
     C     SRCURRDET     BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      CDCCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRTCD         IFNE      *Blanks
     C                   MOVEL     CDCCY         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     002           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
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
      *  SRZDATE2 - Format a Date for Screen Output                   *
      *                                                               *
      *****************************************************************
     C     SRZDATE2      BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *Zero         ZDATE
     C                   PARM      *BLanks       ZADATE
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
      ** INPUT PARAMETERS:
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Collateral details (file format)
     C                   PARM                    CrCoFilFmt
      *
     C                   PARM                    CGL012            1
      *
      ** OUTPUT PARAMETERS:
      *
      ** Collateral details (in screen format)
     C                   PARM                    NwCoScnFmt
      *
      ** Transaction Status
     C                   PARM                    TransStat         7
      *
      ** Move program name into *LDA field.
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'GLCOLLCVT  ' DBPGM
     C                   OUT       LDA
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
      *                                                                                       CGL072
      ** Access SAR details file to determine if CGL072 is on.                                CGL072
      *                                                                                       CGL072
     C                   CALLB     'AOSARDR0'                                                 CGL072
     C                   PARM      *BLANKS       @RTCD                                        CGL072
     C                   PARM      '*VERIFY'     @OPTN                                        CGL072
     C                   PARM      'CGL072'      @SARD                                        CGL072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL072
      *                                                                                       CGL072
     C     @RTCD         IFEQ      *BLANK                                                     CGL072
     C                   MOVE      'Y'           CGL072            1                          CGL072
     C                   ELSE                                                                 CGL072
     C                   MOVE      'N'           CGL072                                       CGL072
     C                   END                                                                  CGL072
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
(c) Misys International Banking Systems Ltd. 2001
