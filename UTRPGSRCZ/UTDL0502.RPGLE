     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*CRT *  CRTBNDRPG                                                    *
/*CRT *  PGM(**********/**********)                                   *
/*CRT *  SRCFILE(**********/**********)                               *
/*CRT *  SRCMBR(*PGM)  TGTRLS(V5R3M0)                                 *
/*EXI *  TEXT('Midas UT Check corrupted FSRRAT field in historic')    *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  UTDL0502 - Check corrupted FSRRAT field in historic files    *
      *                                                               *
      *  Function:  This program will check corrupted FSRRAT field    *
      *  (I/C)      in DLBHISPD, DLCHISPD and DLDHISPD.               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Called By : UTCDL0502                                        *
      *                                                               *
      *  Last Amend No. AR317892 *Create   Date 26Jul12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR317892 - Utility that will check corrupted FSRRAT fields   *
      *             in DLBHISPD, DLCHISPD and DLDHISPD.               *
      *                                                               *
      *****************************************************************
     FDLBHISPD  UF   E           K DISK    INFSR(*PSSR)
     FDLCHISPD  UF   E           K DISK    INFSR(*PSSR)
     FDLDHISPD  UF   E           K DISK    INFSR(*PSSR)
     FUTDL0502AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
     FUTDL0502P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
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
 
     D SPOOLU          DS
      ** File Information Data Structure for UTDL0502AU.
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SPOOL1          DS
      ** File Information Data Structure for UTDL0502P1.
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D DLBHDS        E DS                  EXTNAME(DLBHISPD)
     D                                     PREFIX(B_)
      ** Data Structure to check for uninitialised fields DLBHISPD.
     D #FSRRATB                       7A   OVERLAY(B_FSRRAT)
 
     D DLCHDS        E DS                  EXTNAME(DLBHISPD)
     D                                     PREFIX(C_)
      ** Data Structure to check for uninitialised fields DLCHISPD.
     D #FSRRATC                       7A   OVERLAY(C_FSRRAT)
 
     D DLDHDS        E DS                  EXTNAME(DLBHISPD)
     D                                     PREFIX(D_)
      ** Data Structure to check for uninitialised fields DLDHISPD.
     D #FSRRATD                       7A   OVERLAY(D_FSRRAT)
 
      ** Data Structures for use with access programs
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** Data Structure for Bank details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs, Short Data Structure
 
     D PRTCD           S              7A
     D POPTN           S              7A
     D @RUN            S              1A
 
      /EJECT
     IDLBHISD0
      ** Rename fields of DLBHISPD
     I              DLNO                        B_DLNO
     I              ORED                        B_ORED
     I              FSRRAT                      B_FSRRAT
 
     IDLCHISD0
      ** Rename fields of DLCHISPD
     I              DLNO                        C_DLNO
     I              ORED                        C_ORED
     I              FSRRAT                      C_FSRRAT
 
     IDLDHISD0
      ** Rename fields of DLDHISPD
     I              DLNO                        D_DLNO
     I              ORED                        D_ORED
     I              FSRRAT                      D_FSRRAT
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main body                                              *
      *                                                               *
      *****************************************************************
 
      ** Check for FX in historic which has corrupted FSRRAT field
     C                   READ      DLBHISD0                               01
     C     *IN01         DOWEQ     *OFF
 
      ** Then check if numeric
     C                   TESTN                   #FSRRATB                 02
 
     C     *IN02         IFEQ      *ON
     C                   ADD       1             RCODLB
     C                   MOVEL     'DLBHISPD'    RFILE
     C                   MOVEL     B_DLNO        RDLNO
 
     C                   CALL      'ZDATE2'
     C                   PARM      B_ORED        ZDAYNO            5 0
     C                   PARM      BJDFIN        ZDATFM            1
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
     C                   MOVEL     ZADATE        RORED
 
     C                   EXSR      WP1REC
 
      ** In update mode, re-initialize the FSRRAT field to zero
     C     PMODE         IFEQ      'U'
     C                   Z-ADD     *ZERO         B_FSRRAT
     C                   UPDATE    DLBHISD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       1             RNODLB
     C                   READ      DLBHISD0                               01
 
     C                   ENDDO
 
      ** Check for MM in historic which has corrupted FSRRAT field
     C                   READ      DLCHISD0                               01
     C     *IN01         DOWEQ     *OFF
 
      ** Then check if numeric
     C                   TESTN                   #FSRRATC                 02
 
     C     *IN02         IFEQ      *ON
     C                   ADD       1             RCODLC
     C                   MOVEL     'DLCHISPD'    RFILE
     C                   MOVEL     C_DLNO        RDLNO
 
     C                   CALL      'ZDATE2'
     C                   PARM      C_ORED        ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        RORED
 
     C                   EXSR      WP1REC
 
      ** In update mode, re-initialize the FSRRAT field to zero
     C     PMODE         IFEQ      'U'
     C                   Z-ADD     *ZERO         C_FSRRAT
     C                   UPDATE    DLCHISD0
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ADD       1             RNODLC
     C                   READ      DLCHISD0                               01
 
     C                   ENDDO
 
      ** Check for NASP in historic which has corrupted FSRRAT field
     C                   READ      DLDHISD0                               01
     C     *IN01         DOWEQ     *OFF
 
      ** Then check if numeric
     C                   TESTN                   #FSRRATD                 02
 
     C     *IN02         IFEQ      *ON
     C                   ADD       1             RCODLD
     C                   MOVEL     'DLDHISPD'    RFILE
     C                   MOVEL     D_DLNO        RDLNO
 
     C                   CALL      'ZDATE2'
     C                   PARM      D_ORED        ZDAYNO
     C                   PARM      BJDFIN        ZDATFM
     C                   PARM                    ZDATE
     C                   PARM                    ZADATE
     C                   MOVEL     ZADATE        RORED
 
      ** In update mode, re-initialize the FSRRAT field to zero
     C     PMODE         IFEQ      'U'
     C                   Z-ADD     *ZERO         D_FSRRAT
     C                   UPDATE    DLDHISD0
     C                   ENDIF
 
     C                   EXSR      WP1REC
     C                   ENDIF
 
     C                   ADD       1             RNODLD
     C                   READ      DLDHISD0                               01
 
     C                   ENDDO
 
     C     WOPNP1        IFEQ      'Y'
     C                   EXSR      WP1END
     C                   ENDIF
 
     C                   EXSR      SRAUDIT
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WP1REC - Subroutine to Write a Detail record to the Report.  *
      *                                                               *
      *****************************************************************
     C     WP1REC        BEGSR
 
     C     WOPNP1        IFNE      'Y'
     C                   OPEN      UTDL0502P1
     C                   MOVE      'Y'           WOPNP1            1
     C                   ENDIF
 
      *----------------------------------------------------------------
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
     C                   Z-ADD     1             RQDLN1            3 0
     C     OFLLN1        SUB       PRTLN1        DIFLN1            3 0
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     UTHEADP1
     C                   ENDIF
 
      ** Write out Detail Record.
     C                   WRITE     UTDETLP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  WP1END - Subroutine to Write End of Report.                  *
      *                                                               *
      *****************************************************************
     C     WP1END        BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     UTHEADP1
     C                   ENDIF
 
      ** Write out Trailer Format.
     C                   WRITE     TRAILP1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Output Report Header and File Controls.
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information.
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message.
     C     RCODLB        IFEQ      *ZERO
     C     RCODLC        ANDEQ     *ZERO
     C     RCODLD        ANDEQ     *ZERO
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return.
     C                   SETON                                        LR
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMODE             1
 
     C     PMODE         IFEQ      'U'
     C                   MOVEL     *ON           *IN50
     C                   ENDIF
 
      ** Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     PRTCD         IFNE      *BLANK
     C                   MOVEL     POPTN         DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
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
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2012
