     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Drop Records from Compliance Watch List')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000906 - Drop Records from Compliance Watch List File      *
      *                                                               *
      *  Called By: SDC000906 - Drop Records from Compliance Watch    *
      *             List File                                         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSD083  *CREATE    Date 27May10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    21         Print Function fields                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRPROC - Detail Processing                                    *
      * SRAUDT - Audit Printing                                       *
      * SRPRNT - Detail Printing                                      *
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
 
      ** Compliance Watch Hit List File
     FSDCWDFPD  UF   E             DISK             INFSR(*PSSR)
 
      ** Compliance Watch Hit List Details Dropped Printer File
     FSD000906P1O    E             PRINTER USROPN
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** Compliance Watch Hit List Details Dropped Printer File (Audit)
     FSD000906AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      *****************************************************************
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
 
      ** File Information Data Structure for SD000906P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
     D  OflLn1               188    189B 0
     D  PrtLn1               367    368B 0
 
      ** File Information Data Structure for SD000906AU
     D SPOOLU          DS
     D  PSFileU               83     92
     D  PSFNumU              123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSnumU          S              6  0
     D ZSerr           S              1
 
     D RqdLn1          S              3P 0
     D DifLn1          S              4P 0
     D WorkNum         S              5P 0
 
     D ZDATE           S              6  0
     D ZADATE          S              7
 
     D WError          S              1
     D PRetCode        S              7
     D NewPage         S              1
     D PrntHd          S              1
 
      ** Parameters for access object programs
     D PRTCD           S              7
     D POPTN           S              7
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      *
      ** Initialise Report Work fields
      *
     C                   EVAL      RqdLn1  = 0
     C                   EVAL      DifLn1  = 0
     C                   EVAL      PRTOTD  = 0
     C                   EVAL      PrtLn1  = 0
     C                   EVAL      WError = 'N'
     C                   EVAL      NewPage = 'N'
     C                   EVAL      PrntHd = 'N'
 
     C                   EXSR      SRPROC
 
     C                   EXSR      SRAUDT
 
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
      *
      ** Print Header
      *
      *
      ** Check transaction data file
      *
     C                   READ      SDCWDFPD
 
     C                   DOW       NOT %EOF(SDCWDFPD)
 
     C                   EVAL      WorkNum = WorkNum + 1
      *
      ** Print record if Process flag is equal to 'Y'
      *
     C                   IF        WIPROC = 'Y'
     C                   IF        PRNTHD = 'N'
     C                   WRITE     HEADP1
     C                   EVAL      PrntHd = 'Y'
     C                   ENDIF
     C                   EXSR      SRPRNT
      *
      ** Delete record from file
      *
     C                   DELETE    SDCWDFPD
     C                   ENDIF
 
     C                   READ      SDCWDFPD
 
     C                   ENDDO
      *
      ** When EOF, write trailer
      *
     C                   IF        %EOF(SDCWDFPD)
 
     C                   EVAL      RqdLn1 = 8
     C                   EXSR      SRCHKLIN
 
     C                   IF        PrntHd = 'Y'
     C                   WRITE     TRAILP1
     C                   ENDIF
 
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
      * Calls: SRBRCH                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRPRNT        BEGSR
      *
      ** Check for overflow
      *
     C                   EVAL      RqdLn1 = 14
     C                   EXSR      SRCHKLIN
      *
      ** Put details to printer fields.
      ** Print Function field only when not equal to previous
      *
     C                   IF        PRFUNT <> WIFUNT
     C                   EVAL      PRFUNT = WIFUNT
     C                   EVAL      *IN21 = *ON
     C                   ELSE
     C                   IF        NewPage = 'Y'
     C                   EVAL      *IN21 = *ON
     C                   EVAL      NewPage = 'N'
     C                   ELSE
     C                   EVAL      *IN21 = *OFF
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      PRIDEN = WIIDEN
     C                   EVAL      PRBRCH = WIBRCH
     C                   EVAL      PRCTYP = WICTYP
     C                   EVAL      PRCUST = WICUST
     C                   EVAL      PRCNUM = WICNUM
     C                   EVAL      PRDDAT = WIDDAT
     C                   EVAL      PRVDAT = WIVDAT
 
     C                   EVAL      PRTOTD = PRTOTD + 1
      *
      ** Write Detail
      *
     C                   WRITE     DETAIL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAUDT - Audit Processing                                     *
      *                                                               *
      * Called by: Main Processing, *INZSR                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRAUDT        BEGSR
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = PSFNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFileU
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   WRITE     HEADAU
 
     C                   IF        WError = 'Y'
     C                   WRITE     DBERROR
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        WorkNum > 0
     C                   Z-ADD     WorkNum       RCOUNT
     C                   Z-ADD     PRTOTD        RPROCS
     C                   Z-ADD     PRTOTD        RDELTD
     C                   WRITE     CONTROL
     C                   ELSE
     C                   WRITE     NODTLS
     C                   ENDIF
      *
      ** End of program
      *
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHKLIN - Checks for printer file overflow condition         *
      *                                                               *
      * Called by: SRPROC, SRPRNT                                     *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRCHKLIN      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     HEADP1
     C                   EVAL      NewPage = 'Y'
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
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'SD000906'
     C                   EVAL      WError = 'Y'
     C                   EXSR      SRAUDT
     C                   ENDIF
 
     C                   OPEN      SD000906P1
      *
      ** Ensure Detail Spool File recorded by RCF.
      *
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSerr
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C                   IF        ZSERR = 'Y'
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
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        RunBefore = *BLANK
     C                   EVAL      RunBefore = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      PRetCode = '*ERROR'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2010
