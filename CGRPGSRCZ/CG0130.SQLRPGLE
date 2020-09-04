     H DEBUG
     H CVTOPT (*GRAPHIC)                                                                    MD054955
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/**** *  RPGBNOCVT                                                    *              CSD053 MD054955
/**** *  RPGCVTOPT1                                                   *              CSD053 MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Ref Integrity Check: Account Identifier')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0130 - Referential Integrity Check                         *
     F*    CGCSCHL3 Correspondent details by account id.              *
     F*    CGCSCHL4 Correspondent details by account charge.          *
     F*    CGCORRL6 Correspondent details by account id.              *
     F*    CGLASCL4 Layout association table by account identifier.   *
     F*                                                               *
     F*  Function:  This program tests the first 10 records and if    *
     F*             any exist the return code will be set to 'CGD1183'*
     F*                                                               *
     F*  Called By:                                                   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD054955           Date 16Dec19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 21Nov94               *
     F*                                                               *
     F*---------------------------------------------------------------*
      *                                                               *
      *  MD054955 - Deliverable Data Split for Correspondence Mgr     *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *         - (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
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
     F/COPY WNCPYSRC,CG0130DFPG
      *
      *  /Copy point for File Definition
      *
     F*CGCSCHL3* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Correspondent Details By account id.
      *
     F*CGCSCHL4* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Correspondent Details By charge account.
      *
     FCGCORRL6  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Correspondent Details By account id.
      *
     FCGLASCL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Layout association table by account identifier.
      *
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D/COPY WNCPYSRC,CG0130DEPG
      *
      *  /Copy point for Arrays
      *
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
      **                                                                                      CSC022
     D/COPY WNCPYSRC,CG0130DIPG
      *
      *  /Copy point for Input Specs
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D CGCSCH        E DS                  EXTNAME(CGCSHJW0)                                MD054955
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
     C**********           PARM           I#CACT 18        Account id.                        CGL029
     C                   PARM                    I#CACT           24
     C                   PARM                    I#CPGM           10            Calling Pgm tr.
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     I/COPY WNCPYSRC,CG0130C
      *
      * Check if account identifier exists on CGCSCHL3.
      *
     C                   EXSR      SRCHL3
      *
      * Check if account identifier exists on CGCSCHL4.
      *
     C                   EXSR      SRCHL4
      *
      * Check if account identifier exists on CGCORRL6.
      *
     C                   EXSR      SRRRL6
      *
      * Check if account identifier exists on CGLASCL4.
      *
     C                   EXSR      SRSCL4
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
      *  SRCHL3   : Process CGCSCHL3                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRCHL3        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCHL3'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#CACT        SETLL     CGCSCHL3                                                 MD054955
     C*****I#CACT        READE     CGCSCHL3                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPMACT = :I#CACT and CPRECI = 'D' and CPMACT <> '          '                  MD054955
     C+ order by CPMACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open ACursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *
      * If record found set return code to CGD1184, and send message.
      *
     C                   MOVEL     'CGD1184'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1248'     CGMSID
     C                   MOVEL     CPCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C*****I#CACT        READE     CGCSCHL3                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C     EXCHL3        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHL4   : Process CGCSCHL4                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRCHL4        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCHL4'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C*****I#CACT        SETLL     CGCSCHL4                                                 MD054955
     C*****I#CACT        READE     CGCSCHL4                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare BCursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPCACT = :I#CACT and CPRECI = 'D' and CPMACT <> '          '                  MD054955
     C+ order by CPCACT, CPCORR, CPPTYP, CPPSTP, CPSEQN                                     MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ open BCursor                                                                        MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
      *
     C******IN90         DOWEQ     *OFF                                         B1          MD054955
     C*****I#NUMR        ANDLT     11                                                       MD054955
     C                   DOW       SQLCODE = 0                                  B1          MD054955
     C                             and I#NUMR < 11                                          MD054955
      *
      * If record found set return code to CGD1184, and send message.
      *
     C                   MOVEL     'CGD1184'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1249'     CGMSID
     C                   MOVEL     CPCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C*****I#CACT        READE     CGCSCHL4                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from BCursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close BCursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
                                                                                            MD054955
     C     EXCHL4        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRRRL6   : Process CGCORRL6                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRRRL6        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRRRL6'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     I#CACT        SETLL     CGCORRL6
     C     I#CACT        READE     CGCORRL6                               90
      *
     C     *IN90         DOWEQ     *OFF                                         B1
     C     I#NUMR        ANDLT     11
      *
      * If record found set return code to CGD1184, and send message.
      *
     C                   MOVEL     'CGD1184'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1250'     CGMSID
     C                   MOVEL     CDCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C     I#CACT        READE     CGCORRL6                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXRRL6        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSCL4   : Process CGLASCL4                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRSCL4        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSCL4'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     I#CACT        SETLL     CGLASCL4
     C     I#CACT        READE     CGLASCL4                               90
      *
     C     *IN90         DOWEQ     *OFF                                         B1
     C     I#NUMR        ANDLT     11
      *
      * If record found set return code to CGD1184, and send message.
      *
     C                   MOVEL     'CGD1184'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1251'     CGMSID
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C     I#CACT        READE     CGLASCL4                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXSCL4        TAG
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
     C                   Z-ADD     5             W0ERNB
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
