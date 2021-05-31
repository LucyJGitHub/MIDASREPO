     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Ref Integrity Check: Group Sets')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0230 - Referential Integrity Check                         *
     F*      CGPTYPL2 Print item type/sub type by group set           *
     F*      CGGSASL1 Group set association retrieval index           *
     F*      CGGSASL3 Group set association by to group set           *
     F*      CGDRVDL3 Derived data elements by Group set              *
     F*      CGRASCL2 RDE association table by group/RDE/Order        *
     F*                                                               *
     F*  Function:  This program tests the first 10 records and if    *
     F*             they exist they cannot then be deleted and        *
     F*             the return code will be set to CGD1202.           *
     F*                                                               *
     F*  Called By:                                                   *
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
      *                 S01522             Date 21Nov94               *
      *                                    Date ddmmmyy               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  S01522 - User Defined Correspondence                         *
     F*                                                               *
     F*****************************************************************
     F*                                                               *
     F*  Indicator usage                                              *
     F*  ~~~~~~~~~~~~~~~                                              *
     F*                                                               *
     F*  90   -    General work indicator                             *
     F*                                                               *
     F*****************************************************************
     F/COPY WNCPYSRC,CG0230DFPG
      *
      *  /Copy point for File Definition
      *
     F*CGPTYPL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Print item type/subtype by group set.
      *
     F*CGGSASL1* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Group set association retrieval index.
      *
     F*CGGSASL3* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Group set association by to group.
      *
     FCGDRVDL3  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Derived data elements by group set.
      *
     F*CGRASCL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * RDE association table by group/RDE/order.
      *
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D/COPY WNCPYSRC,CG0230DEPG
      *
      *  /Copy point for Arrays
      *
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
      **                                                                                      CSC022
     D/COPY WNCPYSRC,CG0230DIPG
      *
      *  /Copy point for Input Specs
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D I#MSG#          DS
     D  I#PTYP                 1     10
     D  I#PSTP                11     20
     D*COPY*CGCPYSRC,SRERRI                                                                 MD054955
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
      **                                                                                      CSC022
     D SCCMT           DS           256
     D  WCMTNO                 1      3  0
     D  WCJOBS                 4    103
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** DS for Switchable Features details                                                   CSC022
      **                                                                                      CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **                                                                                      CSC022
      ** Data Structures used by Access Programs                                              CSC022
      **                                                                                      CSC022
     D CGGSAS        E DS                  EXTNAME(CGGSAJW0)                                MD054955
     D CGPTYP        E DS                  EXTNAME(CGPTYJW0)                                MD054955
     D CGRASC        E DS                  EXTNAME(CGRASJW0)                                MD054955
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
     C                   PARM                    W0RTN             7            Return Code
     C                   PARM                    I#GRPS            6            Group set
     C                   PARM                    I#CPGM           10            Calling Pgm tr.
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     I/COPY WNCPYSRC,CG0230C
      *
      * Check if Group set exists on CGPTYPL2.
      *
     C                   EXSR      SRYPL2
      *
      * Check if Group set exists on CGGSASL1.
      *
     C                   EXSR      SRASL1
      *
      * Check if Group set exists on CGGSASL3.
      *
     C                   EXSR      SRASL3
      *
      * Check if Group set exists on CGDRVDL3.
      *
     C                   EXSR      SRVDL3
      *
      * Check if Group set exists on CGRASCL2.
      *
     C                   EXSR      SRSCL2
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
      *  SRYPL2   : Process CGPTYPL2                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRYPL2        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRYPL2'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#GRPS        SETLL     CGPTYPL2                                                 MD054955
     C*****I#GRPS        READE     CGPTYPL2                               90                MD054955
      *
     C/EXEC SQL                                                                             MD054955
     C+ declare PCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGPTYJW0                                                              MD054955
     C+ where ITGRPS = :I#GRPS and ITRECI = 'D'                                             MD054955
     C+ order by ITGRPS, ITPTYP, ITPSTP                                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open PCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from PCursor into :CGPTYP                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1220'     CGMSID
     C                   MOVEL     ITPTYP        I#PTYP
     C                   MOVEL     ITPSTP        I#PSTP
     C                   MOVEL     I#MSG#        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C*****I#GRPS        READE     CGPTYPL2                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from PCursor into :CGPTYP                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close BCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXYPL2        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRASL1   : Process CGGSASL1                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRASL1        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRASL1'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#GRPS        SETLL     CGGSASL1                                                 MD054955
     C*****I#GRPS        READE     CGGSASL1                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGGSAJW0                                                              MD054955
     C+ where GAFGST = :I#GRPS and GARECI = 'D'                                             MD054955
     C+ order by GAFGST, GALGST                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1221'     CGMSID
     C                   EXSR      CGSNMS
      *
     C*****I#GRPS        READE     CGGSASL1                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXASL1        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRASL3   : Process CGGSASL3                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRASL3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRASL3'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#GRPS        SETLL     CGGSASL3                                                 MD054955
     C*****I#GRPS        READE     CGGSASL3                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare BCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGGSAJW0                                                              MD054955
     C+ where GALGST = :I#GRPS and GARECI = 'D'                                             MD054955
     C+ order by GALGST, GAFGST                                                             MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open BCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1222'     CGMSID
     C                   MOVEL     GALGST        CGMSDT
     C                   EXSR      CGSNMS
      *
     C*****I#GRPS        READE     CGGSASL3                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGGSAS                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close BCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXASL3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRVDL3   : Process CGDRVDL3                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRVDL3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRVDL3'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     I#GRPS        SETLL     CGDRVDL3
     C     I#GRPS        READE     CGDRVDL3                               90
      *
     C     *IN90         DOWEQ     *OFF                                         B1
     C     I#NUMR        ANDLT     11
      *
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1223'     CGMSID
     C                   MOVEL     DDRDE         CGMSDT
     C                   EXSR      CGSNMS
      *
     C     I#GRPS        READE     CGDRVDL3                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXVDL3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSCL2   : Process CGRASCL2                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRSCL2        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSCL2'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#GRPS        SETLL     CGRASCL2
     C*****I#GRPS        READE     CGRASCL2                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare RCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGRASJW0                                                              MD054955
     C+ where RAGRPS = :I#GRPS and RARECI = 'D'                                             MD054955
     C+ order by RAGRPS, RASEQA, RARDE                                                      MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open RCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *                                                                                     MD054955
      *
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1224'     CGMSID
     C                   EXSR      CGSNMS
      *
     C*****I#GRPS        READE     CGRASCL2                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from RCursor into :CGRASC                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXSCL2        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT   : Initialisation                                    *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
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
      *  Indicate that set up is complete
      *
     C                   SETON                                        50
      *
      *  Define the number of records to process.
      *
     C                   Z-ADD     10            I#NUMR            2 0
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
      **                                                                                      CSC022
      ** Initialize CSC022 and Skip Commit/Rollback flags                                     CSC022
      **                                                                                      CSC022
     C                   MOVE      'N'           CSC022            1
     C                   MOVE      'N'           WCMTSK            1
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       P@RTCD            7
     C                   PARM      '*VERIFY '    P@OPTN            7
     C                   PARM      'CSC022'      P@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT
     C                   IN        SCCMT
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50
     C     *IN50         IFEQ      *ON
     C                   MOVE      'Y'           WCMTSK
     C                   ENDIF
     C                   ENDIF
      **                                                                                      CSC022
     C                   ELSE
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'
     C                   MOVEL     'CSC022'      W0KEY
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   Z-ADD     1             W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      **                                                                                      CSC022
     C                   ENDIF
      **                                                                                      CSC022
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD054955
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD054955
     C*COPY*CGCPYSRC,SCGSNMSC                                                               MD054955
     C/COPY CGCPYSRC,SCGSNMSCLE                                                             MD054955
     C*COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
**CTDATA CPY@
(c) Finastra International Limited 2001
