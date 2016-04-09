     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ME Incoming MT920 Report')
      *****************************************************************
      *                                                               *
      *  Midas - SWIFT Direct Link Module                             *
      *                                                               *
      *  ME000090 - Incoming MT920 Report                             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL013 *CREATE     Date 10Jun02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL013 - MT94x Message Generation                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         EOF of MEI920L0                                 *
      *    02         READE Fail in MEP920L0                          *
      *    05         From and To Dates indicator                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRINIT - Initialisation                                       *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
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
 
      ** Midas ME Incoming MT920 Audit File
     FMEI920L0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas ME Incoming MT920 Parts
     FMEP920L0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Incoming MT920s Audit Report
     FME000090AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** Incoming MT920s Detail Report
     FME000090P1O    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **--------------------------------------------------------------------------------------------
      ** Standard D Specifications
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for Midas Modules Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs - long  data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** RUNDAT dataarea
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA(RUNDAT)
 
     D MONTHS          S              3    DIM(12) CTDATA PERRCD(12)
 
      **  Parameters - 100 long string passed to RCF
     D PParm           DS            12
     D  WFMDAT                 1      6
     D  WFMYY                  1      2
     D  WFMMM                  3      4
     D  WFMDD                  5      6
     D  WTODAT                 7     12
     D  WTOYY                  7      8
     D  WTOMM                  9     10
     D  WTODD                 11     12
 
      **  Data structure for Date of Generation (yymmdd)
     D WADATE          DS
     D  GENYY                  1      2
     D  GENMM                  3      4  0
     D  GENDD                  5      6
 
      **  Data structure for Date of Generation (yymmdd)
     D W@DATE          DS
     D  GEN@Y                  1      2  0
     D  GEN@M                  3      4  0
     D  GEN@D                  5      6  0
 
      **  Data structure for Time of Generation (hh:mm:ss)
     D WATIME          DS
     D  GENHH                  1      2
     D  GENMN                  3      4
     D  GENSS                  5      6
 
      **  Data structure for FROM date (ddmmyy or mmddyy)
     D FMDAT           DS
     D  FMDM                   1      4
     D  FMYY                   5      6
 
      **  Data structure for TO date (ddmmyy or mmddyy)
     D TODAT           DS
     D  TODM                   1      4
     D  TOYY                   5      6
 
      **  Data structure for Gen date (ddmmyy or mmddyy)
     D GENDAT          DS
     D  GENDM                  1      4  0
     D  GENYR                  5      6  0
 
      ** Parameters for ZSEDIT
     D PZFld15         S             15  0
     D PZDecs          S              1  0
     D PZECode         S              1
     D PZOut21         S             21
 
      ** File Information Data Structure for RE102007P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for RE102007AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D SEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
     D PSARD           S              6
     D PCURR           S              3
 
      ** Parameter for calling ZDATE2
     D PDayN           S              5P 0
     D PFMT            S              1
     D PDATE           S              6  0
     D PADATE          S              7
     D GenDayN         S              5P 0
     D FMDayN          S              5P 0
     D TODayN          S              5P 0
 
      ** Parameter for program entry
     D PLevel          S              1
     D PEnty           S              3
 
     D DifLn1          S              4P 0
     D RqdLn1          S              3P 0
     D KeyIMIR         S                   LIKE(MPIMIR)                         Network
     D WDate           S              6A
     D WYear           S              2A
     D WMon            S              2A
     D WDay            S              2A
     D WMonth          S              3A
     D X               S              2  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
     C                   EXSR      SRINIT
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINIT - Initialisation                                       *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRRCFAU, ZAVDATE                                       *
      *                                                               *
      *****************************************************************
 
     C     SRINIT        BEGSR
 
      ** RCF Processing for Audit File.
 
     C                   EXSR      SRRCFAU
 
      ** Report Work fields.
 
     C                   EVAL      RqdLn1  = 3
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RCount  = 0
     C                   EVAL      PrtLn1  = 0
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPRNT                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      *IN04 = *OFF
 
      ** RCF Processing for printer file
 
     C                   CLOSE     ME000090P1
     C                   OPEN      ME000090P1
     C                   EXSR      SRRCFP1
 
     C     *LOVAL        SETLL     MEI920L0
     C                   READ      MEI920L0                               01
     C                   DOW       *IN01 = *OFF
     C                   EVAL      KeyIMIR = MIIMIR
     C     KMEP          SETLL     MEP920L0
     C     KMEP          READE     MEP920L0                               02
     C                   DOW       *IN02 = *OFF
     C                   EXSR      SRPRNT
     C     KMEP          READE     MEP920L0                               02
     C                   ENDDO
     C                   READ      MEI920L0                               01
     C                   ENDDO
 
      ** When EOF, write trailer
 
     C                   IF        *IN01 = *ON
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   IF        RCount > 0
     C                   WRITE     TRAIL
     C                   ENDIF
 
     C                   CLOSE     ME000090P1
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZAVDATE                                                *
      *                                                               *
      *****************************************************************
     C     SRPRNT        BEGSR
 
      ** Obtain Transaction Reference and MIR
 
     C                   EVAL      RTRNO = MIITRN
     C                   EVAL      RMIR  = MIIMIR
 
      ** Obtain Message Type
 
     C                   EVAL      RMTYP = MPMSGR
 
      **  Obtain Account
 
     C                   EVAL      RACC = MPACTR
 
      ** Obtain Received Date
 
     C                   MOVE      MIRCVD        WDate
     C                   EVAL      WYear = %SUBST(WDate:1:2)
     C                   EVAL      WMon = %SUBST(WDate:3:2)
     C                   EVAL      WDay = %SUBST(WDate:5:2)
 
     C                   MOVE      WMon          X
     C                   MOVE      MONTHS(X)     WMonth
 
     C                   IF        BJDFIN = 'M'
     C                   EVAL      RRCVD = WMonth + WDay + WYear
     C                   ELSE
     C                   EVAL      RRCVD = WDay + WMonth + WYear
     C                   ENDIF
 
      ** Obtain Received Time
 
     C                   EVAL      RTIME = MIRCVT
 
      **  Obtain Outgoing details
 
     C                   EVAL      RGMTP = MPMSGR
     C                   EVAL      RTRN = *BLANKS
     C                   EVAL      RNARR = *BLANKS
 
     C                   If        MPM94X <> *BLANKS
     C                   EVAL      RTRN = MPM94X
     C                   EVAL      RGMTP = MPMSGR
     C                   Endif
 
     C                   If        MPM995 <> *BLANKS
     C                   EVAL      RTRN = MPM995
     C                   EVAL      RGMTP = '995'
     C                   EVAL      RNARR = MPNAR1
     C                   Endif
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        RCOUNT = 0 OR
     C                             DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Write Detail
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Printing                                       *
      *                                                               *
      * Called by: Main Processing, SRPROC, *PSSR                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
 
      ** Write Audit Header
 
     C                   WRITE     HEADAU
 
     C                   IF        *INU7 = '1' AND
     C                             *INU8 = '1'
 
      ** Write Database Error Report
 
     C                   WRITE     DBERROR
     C                   ELSE
 
     C                   IF        RCOUNT = 0
 
      ** Write No Details to Report
 
     C                   WRITE     NODTLS
     C                   ELSE
 
      ** Write Audit Control Report
 
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP1 - Detail Spool File recorded by RCF                   *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Detail Spool File recorded by RCF.
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFAU - Audit Spool File recorded by RCF                    *
      *                                                               *
      * Called by: SRINIT                                             *
      *                                                               *
      * Calls: ZSFILE                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   EVAL      ZSnumU = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *Blanks       SEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnumU
     C                   PARM      *Blank        ZSerr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C     ZSERR         IFEQ      'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: AOBANKR0, AOSARDR0                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PParm
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      RDESC  = 'Call to AOBANKR0 in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Key List
 
     C     KMEP          KLIST
     C                   KFLD                    KeyIMIR
 
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * * P S S R --- A B N O R M A L  E R R O R  C O N D I T I O N S
     C/COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
**  MONTHS - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
