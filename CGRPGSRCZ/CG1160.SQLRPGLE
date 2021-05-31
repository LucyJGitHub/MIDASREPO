     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Report Group Set Structure')
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                          *
     F*                                                               *
     F*  CG1160 - Report Group Set Structure                          *
     F*                                                               *
     F*  Function:  This program xxxxxxxxxxxxxxxxxxxxxxxxxxxx         *
     F*  (phase(s))                                                   *
     F*                                                               *
     F*  Called By: mmCnnnn - (program name)                          *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 126690             Date 26Nov97               *
      *                 086148             Date 21Feb95               *
     F*                 S01522             DATE 30NOV94               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
     F*  126690 - Expand Report Data Element Detail Line              *
     F*  086148 - Pad extracted path with blanks                      *
     F*  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  03   -    Overflow on printer file                           *
     F*  50   -    First Cycle processing                             *
     F*  70   -    Multi-branched indicator - Off = multibranched     *
     F*  90   -    General work indicator                             *
     F*  91   -    General work indicator                             *
     F*                                                               *
     F*****************************************************************
     F/COPY WNCPYSRC,CG1160DFPG
      *
      *  /Copy point for File Definition
      *
     FCG1160P1  O    E             PRINTER INFSR(SRFILE)
     F                                     OFLIND(*IN03)
     F                                     USROPN
     F                                     INFDS(PRTINF)
      *
      * Transaction Report
      *
     F*CGGSETL1* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RTV : Group Set Definition      Retrieval index
      *
     F*CGRDTAL1* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RTV : Report Data Elements      Retrieval index
      *
     F*CGRASCL2* IF   E           K DISK    USROPN                                          MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RSQ : RDE Association Table     By Group/RDE/Order
      *
     FCGPATHL2  IF   E           K DISK    USROPN
     F                                     INFSR(SRFILE)
      *
      * RSQ : Path                      By Group sets
      *
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
      *
      *  End of Copysource for error processing
      *
      *
      *  Copyright table
      *
     D CMD@            S             80    DIM(2) CTDATA PERRCD(1)
      *
      *  Array of QCMDEXC commands
      *
     D EDT             S              1    DIM(80)
      *
      *  Array of QCMDEXC command to edit
      *
     D/COPY WNCPYSRC,CG1160DEPG
      *
      *  /Copy point for Arrays
      *
     D/EJECT
     D/COPY WNCPYSRC,CG1160DIPG
      *
      *  /Copy point for Input Specs
      *
     D/EJECT
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D  CPY@##                 1     20
      *
     D CGGSET        E DS                  EXTNAME(CGSETJW0)                                MD054955
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
     D CGRDTA        E DS                  EXTNAME(CGRDTJW0)                                MD054955
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
      *
      *  End of Program Error Processing copysource member
      *
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      * Bank details Structure *
      *
     D PRTINF          DS
      *
      * Printer file information data structure.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Data Structures used by Access Programs
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      * Data Structures used by Access Programs
      *
     D I#DTA           DS           256
      *
      *  Input parameters data structure
      *
      *           Spool file name (if blank, name unchanged).
      *                 N.B. To change name I#SPLR must be Y
      *                 Unless first call of program
      *
     D  I#SPLN                 1     10
      *
      *           Repeat open and close of spool file
      *                 If Y create new spool file
      *
     D  I#SPLR                11     11
      *
      *           Report Reference if Access checking is off
      *
     D  I#REFN                12     21
      *
      *           Report Override Flag / Page No.
      *
     D  I#ROVR                22     22
     D  I#PAGE                23     25  0
      *
      *           Report Title/Underline (uses msg ID on CGUSRMSG)
      *
     D  I#TITL                26     32
     D  I#TUL                 33     39
      *
      *  Define fields for group set printing
      *
     D  I#TGRP                40     45
     D  I#GRPS                46     51
     D I#PATH          DS           256
      *
      *  Input parameters data structure
      *
     D  I#PTH1                 1    120
     D  I#PTH2               121    240
      *
     D DSMTR           DS
      *
      *  Define fields for message transalation
      *
     D  #MSDTA                 1    132
     D  #MSTX1               133    264
     D #MSTX2          DS
     D  #MSTXA                 1    256
     D  #MSTXB               257    512
      *
     I/EJECT
      *****************************************************************
      *                 M A I N L I N E
      *****************************************************************
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *  Define entry parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    W0RTN             7
     C                   PARM                    W0ACT             8
     C                   PARM                    I#DTA                          Input Data Str.
     C                   PARM                    I#PATH                         Input Path
     C                   PARM                    I#RSQN            5
      *
      *  Set up primary reference
      *
     C                   MOVEL     I#DTA         W0PREF
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
      *  If action is *CLOSE then call SROPT and close down program
      *
     C     W0ACT         IFEQ      '*CLOSE'
     C                   EXSR      SROPRT
     C                   MOVEL     '1'           *INLR
     C                   RETURN
     C                   END
      *
      *  Check action code and get set data
      *
     C                   EXSR      SRCHCK
      *
      *  Call subroutine depending on action code
      *
     C     W0ACT         CASEQ     '*TOPSET'     SRTGRP
     C     W0ACT         CASEQ     '*GROUP '     SRGRPS
     C     W0ACT         CASEQ     '*CLOSESP'    SROPRT
     C                   CAS                     SRACT
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      * Return to calling program
      *
     C                   RETURN
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHCK   : Check true action code                            *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRCHCK        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCHCK'      @STK(Q)
      *
      *  Set Detail headings print off
      *
     C                   MOVEL     *BLANKS       WKDH              1
      *
      *  Check that it is a valid action code
      *
     C     W0ACT         IFEQ      '*CLOSESP'                                   Close spool fil
     C                   GOTO      EXCHCK
     C                   END
      *
      *  If valid action code, check that message reference exists.
      *
      *
     C     W0ACT         IFEQ      '*TOPSET'
      *
     C                   MOVEL     I#TGRP        KFGRPS
     C*****KYGRPS        CHAIN     @GSETL1                            90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :I#TGRP and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGGSETL1'    W0FILE                         ***************
     C                   MOVEL     I#TGRP        W0KEY                          * DB ERROR 01 *
     C                   Z-ADD     1             W0ERNB                         ***************
     C                   MOVEL     'CGD1115'     W0MSGD
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Set up fields for header
      *
     C                   MOVEL     GSGRPS        H3GRPS
     C                   MOVEL     GSDESC        H3DESC
     C                   MOVEL     GSCSET        H3CSET
     C                   MOVEL     GSMREC        H3MREC
     C                   MOVEL     GSRSET        H3RSET
     C                   MOVEL     GSMMGR        H3MMGR
      *
      *  Retrieve title for report dependant on type of report
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      I#TITL        #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TITL           60
      *
      *  Retrieve title underline
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      I#TUL         #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C                   MOVEL     #MSTX1        H2TUL            60
      *
      *  Set up report reference
      *
     C                   MOVEL     I#REFN        H1REFN
      *
     C                   END
      *
      *  Set up fields for simple set
      *
     C     W0ACT         IFEQ      '*GROUP '
      *
     C                   MOVEL     I#GRPS        KFGRPS
     C*****KYGRPS        CHAIN     @GSETL1                            90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :I#GRPS and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGGSETL1'    W0FILE                         ***************
     C                   MOVEL     I#GRPS        W0KEY                          * DB ERROR 02 *
     C                   Z-ADD     2             W0ERNB                         ***************
     C                   MOVEL     'CGD1115'     W0MSGD
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Set up fields for header
      *
     C                   MOVEL     GSGRPS        D1GRPS
     C                   MOVEL     GSDESC        D1DESC
     C                   MOVEL     GSCSET        D1CSET
     C                   MOVEL     GSMREC        D1MREC
     C                   MOVEL     GSRSET        D1RSET
     C                   MOVEL     GSMMGR        D1MMGR
      *
      * If printing top group set structure get path information
      *
     C     H3CSET        IFEQ      'T'
     C                   MOVEL     I#PTH1        D2PTH1
     C                   MOVEL     I#PTH2        D2PTH2
     C                   EXSR      SRPATH
     C                   END
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXCHCK        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRTGRP   : Process printing requirements                     *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SROPRT - Open Printer File                        *
      *             SRHDR1 - Print Header of Report                   *
      *             SRHDR2 - Print Title of Report                    *
      *             SRHDR3 - Print Top Group Set                      *
      *                                                               *
      *****************************************************************
     CSR   SRTGRP        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRTGRP'      @STK(Q)
      *
      *  Open printer file etc
      *
     C                   EXSR      SROPRT
      *
      *  Print header of report
      *
     C                   EXSR      SRHDR1
      *
      *  Retrieve Title of report and print
      *
     C                   EXSR      SRHDR2
      *
      *  Report Top Group Set Information
      *
     C                   EXSR      SRHDR3
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXTGRP        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRGRPS   : Print Group Set Information                       *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SROPRT - Open Printer File                        *
      *                                                               *
      *****************************************************************
     CSR   SRGRPS        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRGRPS'      @STK(Q)
      *
      *  Print Group Set Information
      *
     C                   EXSR      SRDTL1
      *
      *  Print Path information if Top Set structure
      *
     C     H3CSET        IFEQ      'T'
     C                   EXSR      SRDTL2
     C                   END
      *
      *  Report Report Data Element Information if simple
      *
     C     D1CSET        IFEQ      'N'
     C                   EXSR      SRDTL3
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXGRPS        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRHDR1   : Print Page Header                                 *
      *                                                               *
      *  CALLED BY: SRNONE - Print no information for combination     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRHDR1        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRHDR1'      @STK(Q)
      *
      *  /Copy point for Header print 1
      *
     C/COPY WNCPYSRC,CG1160DPH1
      *
      *
      *  Write page header and switch off overflow indicator
      *
     C                   WRITE     F0HDR1
     C                   MOVEL     '0'           *IN03
      *
      *  /Copy point for Header print
      *
     C/COPY WNCPYSRC,CG1160HDR1
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXHDR1        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRHDR2   : Print Report Title                                *
      *                                                               *
      *  CALLED BY: SRSUMM - Print Summary Transaction Report         *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRHDR2        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRHDR2'      @STK(Q)
      *
      *  /Copy point for Header print 2
      *
     C/COPY WNCPYSRC,CG1160DPH2
      *
      *
      *  Write title
      *
     C                   WRITE     F0HDR2
      *
      *  /Copy point for Header print
      *
     C/COPY WNCPYSRC,CG1160HDR2
      *
      *  Unwind subroutine stack name
      *
     C     EXHDR2        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRHDR3   : Print Top Group Set                               *
      *                                                               *
      *  CALLED BY: SRNONE - Print no information for combination     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRHDR3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRHDR3'      @STK(Q)
      *
      *  /Copy point for Header print 3
      *
     C/COPY WNCPYSRC,CG1160DPH3
      *
      *
      *  Write Top Group Set Information
      *
     C                   WRITE     F1HDR1
      *
      *  /Copy point for Header print
      *
     C/COPY WNCPYSRC,CG1160HDR3
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXHDR3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDTL1   : Print Group Set                                   *
      *                                                               *
      *  CALLED BY: SRNONE - Print no information for combination     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRDTL1        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDTL1'      @STK(Q)
      *
      *  /Copy point for detail print 1
      *
     C/COPY WNCPYSRC,CG1160DPD1
      *
      * Print Top Group Set
      *
     C                   EXSR      SRTGRP
      *
      *  Write Group Set Information
      *
     C                   WRITE     F1DTL1
      *
      *  If overflow write out headnt
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SRTGRP
     C                   WRITE     F1DTL1
     C                   END
      *
      *  /Copy point for Detail print
      *
     C/COPY WNCPYSRC,CG1160DTL1
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXDTL1        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDTL2   : Print Path Information                            *
      *                                                               *
      *  CALLED BY: SRNONE - Print no information for combination     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRDTL2        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDTL2'      @STK(Q)
      *
      *  /Copy point for detail print 2
      *
     C/COPY WNCPYSRC,CG1160DPD2
      *
      *
      *  Write Path Information
      *
     C                   WRITE     F1DTL2
      *
      *  If overflow write out headnt
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SRTGRP
     C                   WRITE     F1DTL2
     C                   END
      *
      *  /Copy point for detail print
      *
     C/COPY WNCPYSRC,CG1160DTL2
      *
      *
      *  Unwind subroutine stack name
      *
     C     EXDTL2        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRDTL3   : Print Report Data Element Information             *
      *                                                               *
      *  CALLED BY: SRNONE - Print no information for combination     *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     CSR   SRDTL3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRDTL3'      @STK(Q)
      *
      *  /Copy point for Detail print 3
      *
     C/COPY WNCPYSRC,CG1160DPD3
      *
      *
      *  Write Report Data Element Header
      *
     C                   WRITE     F3DTL1
      *
      *  If overflow write out headnt
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SRTGRP
     C                   WRITE     F3DTL1
     C                   END
      *
      *  /Copy point for Detail print
      *
     C/COPY WNCPYSRC,CG1160DTL3
      *
      *  Set lower limits and read RDEs for group set
      *
     C     KRST          KLIST
     C                   KFLD                    RAGRPS                         Group Set Name
      * Setup key
     C                   MOVEL     D1GRPS        RAGRPS                         Group Set Name
      *
     C*****KRST*         SETLL     @RASCL2                                                  MD054955
      *
     C*****KRST*         READE     @RASCL2                                90    *90=EOF     MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRASJW0                                                              MD054955
     C+ where RAGRPS = :RAGRPS and RARECI = 'D'                                             MD054955
     C+ order by RAGRPS, RASEQA, RARDE                                                      MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ELSE                                                               MD054955
     C                   SETOFF                                       90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
     C     *IN90         IFEQ      '1'
      *
      *  Write No details to report
      *
     C                   WRITE     F5DTL1
      *
      *  If overflow write out headnt
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SRTGRP
     C                   END
      *
     C                   ELSE
      *
      *  Process all RDE records
      *
     C     *IN90         DOUEQ     '1'
      *
      *  Get RDE data
      *
     C     KLRDTA        KLIST
     C                   KFLD                    D4RDE                          Report Data Ele
      * Setup key
     C                   MOVEL     RARDE         D4RDE                          Report Data El
      *
     C*****KLRDTA        CHAIN     @RDTAL1                            91        *           MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGRDTA                                                                        MD054955
     C+ from CGRDTJW0                                                                       MD054955
     C+ where RDRDE = :D4RDE and RDRECI = 'D'                                               MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       91                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        91                    MD054955
     C                   ENDIF                                                              MD054955
      *
      *  If not found error
      *
     C     *IN91         IFEQ      '1'
     C                   MOVEL     'CGRDTAL1'    W0FILE
     C                   MOVEL     D4RDE         W0KEY                          ***************
     C                   Z-ADD     3             W0ERNB                         * DB ERROR 03 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Write RDE record
      *
     C                   MOVEL     RDDESC        D4DESC                         Report Data El
     C                   MOVEL     RDELYP        D4ELYP                         Report Data El 12669
     C                   MOVEL     RDMAXL        D4MAXL                         Report Data El 12669
     C                   MOVEL     RDETXT        D4ETXT                         Report Data El 12669
      *
     C                   WRITE     F4DTL1
      *
      *  Read next record
      *
     C*****KRST*         READE     @RASCL2                                90    *90=EOF     MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ELSE                                                               MD054955
     C                   SETOFF                                       90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If overflow write out headnt
      *
     C     *IN03         IFEQ      '1'
     C                   EXSR      SRTGRP
     C     *IN90         IFEQ      '0'
     C                   WRITE     F3DTL1
     C                   END
     C                   END
     C                   ENDDO
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXDTL3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRPATH   : Look for Path and if not found create             *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRPATH        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRPATH'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG1160PATH
      *
      *  Define key list for path
      *
     C     KPGRPS        KLIST
     C                   KFLD                    EPLEV1
     C                   KFLD                    EPLEV2
     C                   KFLD                    EPLEV3
     C                   KFLD                    EPLEV4
     C                   KFLD                    EPLEV5
     C                   KFLD                    EPLEV6
     C                   KFLD                    EPLEV7
     C                   KFLD                    EPLEV8
     C                   KFLD                    EPLEV9
     C                   KFLD                    EPLEV0
      *
      *  Reset Path group set fields
      *
     C                   MOVEL     *BLANKS       EPLEV1
     C                   MOVEL     *BLANKS       EPLEV2
     C                   MOVEL     *BLANKS       EPLEV3
     C                   MOVEL     *BLANKS       EPLEV4
     C                   MOVEL     *BLANKS       EPLEV5
     C                   MOVEL     *BLANKS       EPLEV6
     C                   MOVEL     *BLANKS       EPLEV7
     C                   MOVEL     *BLANKS       EPLEV8
     C                   MOVEL     *BLANKS       EPLEV9
     C                   MOVEL     *BLANKS       EPLEV0
      *
      *  Find Repeating Path/Top Group Set
      *
     C                   Z-ADD     2             Y#                7 0
     C                   Z-ADD     0             X#                7 0
     C                   Z-ADD     1             C#                5 0
     C                   MOVEL     'N'           ##NONR            1
      *
     C     W0RTN         DOUEQ     'CGD1087'
     C                   EXSR      SRNGRP
      *
      *  Check if group set is top or repeating
      *
     C*****##GSET        CHAIN     @GSETL1                            90                    MD054955
     C/EXEC SQL                                                                             MD054955
     C+ SELECT *                                                                            MD054955
     C+ into :CGGSET                                                                        MD054955
     C+ from CGSETJW0                                                                       MD054955
     C+ where GSGRPS = :##GSET and GSRECI = 'D'                                             MD054955
     C/END-EXEC                                                                             MD054955
     C                   SETOFF                                       90                    MD054955
     C                   If        SQLCODE = 100                                            MD054955
     C                   SETON                                        90                    MD054955
     C                   ENDIF                                                              MD054955
                                                                                            MD054955
      *
      *  If not found error
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CGGSETL1'    W0FILE
     C                   MOVEL     ##GSET        W0KEY                          ***************
     C                   Z-ADD     4             W0ERNB                         * DB ERROR 04 *
     C                   MOVEL     'MEM5004'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      *  Record is a repeating group
      *
     C     GSMREC        IFNE      'N'
     C     ##NONR        ANDEQ     'Y'
     C                   MOVEL     'CGGSETL1'    W0FILE
     C                   MOVEL     ##GSET        W0KEY                          ***************
     C                   Z-ADD     5             W0ERNB                         * DB ERROR 05 *
     C                   MOVEL     'CGD1088'     W0MSGD                         ***************
     C                   MOVEL     'CGUSRMSG'    W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C     GSMREC        IFEQ      'N'
     C     GSCSET        ANDNE     'T'
     C     ##NONR        ANDNE     'Y'
      *
      *  Read path
      *
     C     KPGRPS        CHAIN     @PATHL2                            90
      *
      *  If path not found move 'No Path Text'
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     ##NOPT        D2RPTH
     C                   ELSE
     C                   MOVEL     EPPATH        D2RPTH
     C                   END
      *
      *  Reset Path group set fields
      *
     C                   MOVEL     *BLANKS       EPLEV1
     C                   MOVEL     *BLANKS       EPLEV2
     C                   MOVEL     *BLANKS       EPLEV3
     C                   MOVEL     *BLANKS       EPLEV4
     C                   MOVEL     *BLANKS       EPLEV5
     C                   MOVEL     *BLANKS       EPLEV6
     C                   MOVEL     *BLANKS       EPLEV7
     C                   MOVEL     *BLANKS       EPLEV8
     C                   MOVEL     *BLANKS       EPLEV9
     C                   MOVEL     *BLANKS       EPLEV0
      *
      *  Now find non-repeating path
      *
     C                   Z-ADD     1             C#
     C                   MOVEL     'Y'           ##NONR            1
     C                   END
      *
      * Set up key to path file by group set
      *
     C                   SELECT
     C     C#            WHENEQ    1
     C                   MOVEL     ##GSET        EPLEV1
     C     C#            WHENEQ    2
     C                   MOVEL     ##GSET        EPLEV2
     C     C#            WHENEQ    3
     C                   MOVEL     ##GSET        EPLEV3
     C     C#            WHENEQ    4
     C                   MOVEL     ##GSET        EPLEV4
     C     C#            WHENEQ    5
     C                   MOVEL     ##GSET        EPLEV5
     C     C#            WHENEQ    6
     C                   MOVEL     ##GSET        EPLEV6
     C     C#            WHENEQ    7
     C                   MOVEL     ##GSET        EPLEV7
     C     C#            WHENEQ    8
     C                   MOVEL     ##GSET        EPLEV8
     C     C#            WHENEQ    9
     C                   MOVEL     ##GSET        EPLEV9
     C     C#            WHENEQ    10
     C                   MOVEL     ##GSET        EPLEV0
     C                   ENDSL
      *
      *  Step on level
      *
     C                   ADD       1             C#
     C                   ENDDO
      *
      *  Read path for Non-Repeating Group
      *
     C     KPGRPS        CHAIN     @PATHL2                            90
      *
      *  If path not found add to database
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     ##NOPT        D2NPTH
     C                   ELSE
     C                   MOVEL     EPPATH        D2NPTH
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXPATH        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRNGRP   : Find Next Group                                   *
      *                                                               *
      *  CALLED BY: SRPATH - Process Path                             *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRNGRP        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRNGRP'      @STK(Q)
      *
      *  /COPY for subroutine
      *
     C/COPY WNCPYSRC,CG1160NGRP
      *
      *  Initialise control code
      *
     C                   MOVEL     *BLANKS       W0RTN
     C     *LIKE         DEFINE    EPLEV1        ##GSET
      *
      *  Find First delimter
      *
     C     '\'           SCAN      I#PATH:Y#     X#                       90
      *
      *  If found find length
      *
     C     *IN90         IFEQ      '1'
      *
     C     X#            SUB       Y#            Z#                5 0
     C***********Z#        SUBSTI#PATH:Y# ##GSET                          086148
     C     Z#            SUBST(P)  I#PATH:Y#     ##GSET                                        08614
      *
      *  Set Y# to next free space
      *
     C     X#            ADD       1             Y#
     C                   ELSE
      *
      *  Substring fixed length of six
      *
     C***********6         SUBSTI#PATH:Y# ##GSET                          086148
     C     6             SUBST(P)  I#PATH:Y#     ##GSET                                        08614
     C                   MOVEL     'CGD1087'     W0RTN             7
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXNGRP        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SROPRT   : Control open and close of spool file CG1160P1     *
      *                                                               *
      *  CALLED BY: SRSUMM - Process Summary Transaction Report       *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SROPRT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SROPRT'      @STK(Q)
      *
      *  If first open or I#SPLR is 'Y', open and close file
      *  or close action specified
      *
     C     ##OPRT        IFEQ      *BLANKS
     C     I#SPLR        OREQ      'Y'
     C     W0ACT         OREQ      '*CLOSE'
     C     W0ACT         OREQ      '*CLOSESP'
      *
      *  If open and spool repeat is yes close the file
      *  or if close specified and file open
      *
     C     ##OPRT        IFNE      *BLANKS
     C     I#SPLR        ANDEQ     'Y'
     C     ##OPRT        ORNE      *BLANKS
     C     W0ACT         ANDEQ     '*CLOSE'
     C     ##OPRT        ORNE      *BLANKS
     C     W0ACT         ANDEQ     '*CLOSESP'
      *
      *  /Copy point for End of Report
      *
     C/COPY WNCPYSRC,CG1160DPER
      *
      *
      *  Print end of report before processing close of file
      *
     C                   WRITE     F0TRL1
      *
      *  Close file
      *
     C                   CLOSE     CG1160P1
     C                   MOVEL     *BLANKS       ##OPRT
     C                   Z-ADD     0             PAGE1
      *
      *  If *CLOSE exit section as no more processing
      *
     C     W0ACT         IFEQ      '*CLOSE'
     C     W0ACT         OREQ      '*CLOSESP'
     C                   GOTO      EXOPRT
     C                   END
     C                   END
      *
      *  If spool file name is requested change override
      *
     C     ##OPRT        IFEQ      *BLANKS
     C     I#SPLN        ANDNE     *BLANKS
      *
      *  Override file CG1160P1 share(*NO) and spool file name
      *
     C                   MOVEA     CMD@(1)       EDT
     C                   MOVEA     I#SPLN        EDT(49)
     C                   MOVEA     EDT           OVRDBF           80
     C                   Z-ADD     80            CMDLEN           15 5
     C                   CALL      'QCMDEXC'                              90    90
     C                   PARM                    OVRDBF
     C                   PARM                    CMDLEN
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     '*CALL  '     W0FILE
     C                   MOVEL     'QCMDEXC'     W0KEY
     C                   Z-ADD     6             W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
     C                   END
      *
      *  Open CG1160P1 for output
      *
     C                   OPEN      CG1160P1                             90
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'CG1160P1'    W0FILE                         ***************
     C                   MOVEL     '*OPEN'       W0KEY                          * DB ERROR 07 *
     C                   Z-ADD     7             W0ERNB                         ***************
     C                   MOVEL     'MEM5005'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * If I#SPLN is not blank then this is the name for RCF
      *
     C     I#SPLN        IFNE      *BLANKS
     C                   MOVEL     I#SPLN        UUSFNM
     C                   ELSE
     C                   MOVEL     SFILEU        UUSFNM
     C                   END
      *
      * ZSFILE - Log Spool File
      *
      * Set up spool file number
      *
     C                   Z-ADD     SFNUMU        WUSFNB            6 0
     C                   MOVE      *BLANKS       UUSRSQ            5
     C     *LIKE         DEFINE    UUZSER        WUZSER
      *
      * ZSFILE - write report rqs
      *
     C                   CALL      'ZSFILE'                             90
     C     UUSRSQ        PARM      I#RSQN        UURSQN            5
     C                   PARM      *BLANKS       UUENTY            3
     C                   PARM                    UUSFNM           10
     C                   PARM      WUSFNB        UUSFNB            6 0
     C     WUZSER        PARM      *BLANK        UUZSER            1
      *
      * Report error on call to ZSFILE
      *
     C     *IN90         IFEQ      '1'
     C     WUZSER        OREQ      'Y'
     C                   MOVEL     '*CALL   '    W0FILE                         ***************
     C                   MOVEL     'ZSFILE'      W0KEY                          * DB ERROR 08 *
     C                   Z-ADD     8             W0ERNB                         ***************
     C                   MOVEL     'MEM5003'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
     C                   MOVEL     'Y'           ##OPRT            1
      *
     C                   END
      *
      *  Unwind subroutine stack name
      *
     C     EXOPRT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRACT    : Undefined action - error                          *
      *                                                               *
      *  CALLED BY: Main Processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRACT         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRACT '      @STK(Q)
      *
      *  Database error undefined action
      *
     C                   MOVEL     '*ACTION '    W0FILE                         ***************
     C                   MOVEL     W0ACT         W0KEY                          * DB ERROR 09 *
     C                   Z-ADD     9             W0ERNB                         ***************
     C                   MOVEL     'MEM5006'     W0MSGD
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
      *
      *  Unwind subroutine stack name
      *
     C     EXACT         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialise and define fields                      *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : SRERR   - report error and close down program     *
      *                                                               *
      *****************************************************************
     CSR   SRINIT        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *  Set up copyright statement
      *
     C                   MOVEA     CPY@          ACT@             80
      *
      *  Define fields
      *
     C     *LIKE         DEFINE    GSGRPS        KFGRPS
      *
      *  Key List for CGGSETL1
      *
     C     KYGRPS        KLIST
     C                   KFLD                    KFGRPS                         Group Set Name
      *
      *  Open Files
      *
     C**********         OPEN      CGGSETL1                                                 MD054955
     C**********         OPEN      CGRDTAL1                                                 MD054955
     C**********         OPEN      CGRASCL2                                                 MD054955
     C                   OPEN      CGPATHL2
      *
      *  Get Rundate - Rundate
      *
     C     *DTAARA       DEFINE    RUNDAT        RUNDTA
     C                   IN        RUNDTA
     C                   MOVE      AGMRDT        ##MRDT            7            Midas Run date
     C                   MOVE      AGMRDT        WUMRDT            7            Midas Run date
     C                   MOVE      AGRDNB        WURDNB            5 0          Run day number
     C                   MOVE      AGSUC         WUSUC             1            Set up complete
     C                   MOVE      AGDFF         WUDFF             1            Date Format
     C                   MOVE      AGMBIN        WUMBIN            1            Multi Branched
      *
      * Set multi-branch indicator
      *
     C     WUMBIN        IFNE      'Y'                                          Multi Branched ?
     C                   MOVEL     '1'           *IN70
     C                   END
      *
      *  Extract bank details
      *
     C                   CALL      'AOBANKR0'                           9090
     C                   PARM      *BLANKS       P@RTCD            7            B:Return code
     C                   PARM      '*FIRST '     P@OPTN            7            I:Option
     C     SDBANK        PARM      *BLANKS       DSFDY
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     P@RTCD        OREQ      '*ERROR*'
     C                   MOVEL     'AOBANKR0'    W0FILE
     C                   MOVEL     '*CALL'       W0KEY                          ***************
     C                   Z-ADD     10            W0ERNB                         * DB ERROR 10 *
     C                   MOVEL     'MEM5003'     W0MSGD                         ***************
     C                   MOVEL     'MIDAS  '     W0MSGF
     C                   EXSR      SRERR
     C                   END
      *
      * Get 'No Path' text
      *
     C                   CALL      'CGC1000'                            9090
     C                   PARM      'CGD1121'     #MSGID
     C                   PARM      'CGUSRMSG'    #MSGF
     C                   PARM                    #MSDTA
     C                   PARM      *BLANKS       #MSTX1
     C                   PARM      *BLANKS       #MSTX2
      *
     C     *LIKE         DEFINE    EPPATH        ##NOPT
     C                   MOVEL     #MSTX1        ##NOPT
      *
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     C/COPY WNCPYSRC,CG1160DCPG
      *
      *  /Copy point for Calculation Specs
      *
     C/EJECT
     C*
     C* PSSR Processing
     C*
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C/EJECT
      *
      *  File and Program Error Processing
      *
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
     C/EJECT
     C/COPY WNCPYSRC,CG1160DOPG
      *
      *  /Copy point for Output Specs
      *
**CTDATA CPY@
(c) Finastra International Limited 2001
**CTDATA CMD@
OVRPRTF    FILE(CG1160P1  ) SHARE(*NO) SPLFNAME(XXXXXXXXXX) SECURE(*YES)
OVRDBF     FILE(XXXXXXXXXX) SHARE(*NO) SECURE(*YES)
