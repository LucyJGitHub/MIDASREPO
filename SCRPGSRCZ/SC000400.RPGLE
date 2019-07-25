     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Error Log Report')
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SC000400 - Data Replication Error Log Report Program         *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CSC011  *CREATE    Date 18Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         EOF of SCELOGPD                                 *
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

      ** Data Replication Error Log File
     FSCELOGPD  IF   E             DISK    INFSR(*PSSR)

      ** Data Replication Error Log Audit Report
     FSC000400AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)

      ** Data Replication Error Log Detail Report
     FSC000400P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)

      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
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

      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** File Information Data Structure for SC000400P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0

      ** File Information Data Structure for SC000400AU
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

     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D PNoDtl          S              1

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
      * Calls: SRRCFAU                                                *
      *                                                               *
      *****************************************************************

     C     SRINIT        BEGSR

      ** RCF Processing for Audit File.

     C                   EXSR      SRRCFAU

      ** Report Work fields.

     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      RCount  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      PNoDtl = *BLANK

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPROC - Detail Processing                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRRCFP1, SRAUDT, SRPRNT                                *
      *                                                               *
      *****************************************************************

     C     SRPROC        BEGSR

     C     1             SETLL     SCELOGPD

      ** Data Replication Error Log File

     C                   READ      SCELOGPD                               01

     C                   IF        *IN01 = *ON
     C                   EXSR      SRAUDT
     C                   ELSE
     C                   EXSR      SRRCFP1
     C                   ENDIF

     C                   DOW       *IN01 = *OFF
     C                   EXSR      SRPRNT
     C                   READ      SCELOGPD                               01

      ** When EOF, write trailer

     C                   IF        *IN01 = *ON
     C                   EVAL      RqdLn1 = 3
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

     C                   WRITE     TRAILP1
     C                   ENDIF

     C                   ENDDO

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPRNT - Detail Printing                                      *
      *                                                               *
      * Called by: SRPROC                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     SRPRNT        BEGSR

     C                   EVAL      RqdLn1 = 1
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1

     C                   IF        RCOUNT = 0 OR
     C                             DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   ENDIF

      ** Write details to printer fields.

     C                   EVAL      RFILE = FDERRF
     C                   EVAL      RDESC = FDERRD
     C                   EVAL      RSEQN = FDJSEQ
     C                   EVAL      RTYPE = FDJTYP
     C                   EVAL      RMMBR = FDMEM
     C                   EVAL      RERRN = FDJRRN
     C                   EVAL      RDATA = FDJDAT

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
     C                   EVAL      PNoDtl = 'Y'
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

     C                   OPEN      SC000400P1

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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************

     C     *INZSR        BEGSR

     C     *ENTRY        PLIST
     C                   PARM                    ReturnCode
     C                   PARM                    PNoDtl

     C/COPY ZACPYSRC,DBFIELDS

      ** Access Bank Details

     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY

      ** Database Error

     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'SC000400'
     C                   EXSR      *PSSR
     C                   ENDIF

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: SRAUDT                                                 *
      *                                                               *
      *****************************************************************

     C     *PSSR         BEGSR

     C                   DUMP

     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      ReturnCode = '*ERROR'
     C                   EXSR      SRAUDT

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR

      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
