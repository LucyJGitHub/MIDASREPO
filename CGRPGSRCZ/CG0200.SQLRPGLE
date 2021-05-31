     H DEBUG
      *****************************************************************
/**** *  RPGBASE                                                      *                     MD054955
/*STD *  RPGSQLBND                                                    *                     MD054955
/*EXI *  TEXT('Midas CG Ref Integrity Check: Print Item Types')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0180 - Referential Integrity Check                         *
     F*  CGCSCHL6  - Correspondent schedule by print item type        *
     F*  CGLASCL6  - Layout association table by print item type      *
     F*  CGLAYOL2  - Layout reference by print item type              *
     F*                                                               *
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
     F/COPY WNCPYSRC,CG0200DFPG
      *
      *  /Copy point for File Definition
      *
     F*CGCSCHL6* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Correspondent schedule by print item type
      *
     FCGLASCL6  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Layout association table by print item type
      *
     F*CGLAYOL2* IF   E           K DISK                                                    MD054955
     F**********                           INFSR(SRFILE)                                    MD054955
      *
      * Layout reference by print item type
      *
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD054955
     D/COPY CGCPYSRC,SRERRDLE                                                               MD054955
     D/COPY WNCPYSRC,CG0200DEPG
      *
      *  /Copy point for Arrays
      *
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)
      **                                                                                      CSC022
     D/COPY WNCPYSRC,CG0180DIPG
      *
      *  /Copy point for Input Specs
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D I#PTST          DS
     D  I#PTYP                 1     10
     D  I#PSTP                11     20
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
     C                   PARM                    I#PTST                         Prnt typ/sub
     C                   PARM                    I#CPGM           10            Calling Pgm tr.
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     I/COPY WNCPYSRC,CG0180C
      *
      * Check if print type/sub type exists on CGCSCHL6.
      *
     C                   EXSR      SRCHL6
      *
      * Check if print type/sub type exists on CGLASCL6.
      *
     C                   EXSR      SRSCL6
      *
      * Check if print type/sub type exists on CGLAYOL2.
      *
     C**********         EXSR      SRYOL2                                                   MD054955
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
      *  SRRRLA   : Process CGCSCHL6                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRCHL6        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRCHL6'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     KKEY01        KLIST
     C                   KFLD                    I#PTYP
     C                   KFLD                    I#PSTP
      *
     C*****KKEY01        SETLL     CGCSCHL6                                                 MD054955
     C*****KKEY01        READE     CGCSCHL6                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ declare ACursor insensitive scroll cursor for                                       MD054955
     C+ select * from CGCSHJW0                                                              MD054955
     C+ where CPPTYP = :I#PTYP and CPPSTP = :I#PSTP and CPRECI = 'D'                        MD054955
     C+ order by CPPTYP, CPPSTP, CPCORR, CPSEQN                                             MD054955
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
      * If record found set return code to CGD1202, and send message.
      *
     C                   MOVEL     'CGD1202'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1212'     CGMSID
     C                   MOVEL     CPCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C*****KKEY01        READE     CGCSCHL6                               90                MD054955
     C/EXEC SQL                                                                             MD054955
     C+ fetch next from ACursor into :CGCSCH                                                MD054955
     C/END-EXEC                                                                             MD054955
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C/EXEC SQL                                                                             MD054955
     C+ close ACursor                                                                       MD054955
     C/END-EXEC                                                                             MD054955
     C     EXCHL6        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRCHL7   : Process CGLASCL6                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRSCL6        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRSCL6'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     KKEY01        SETLL     CGLASCL6
     C     KKEY01        READE     CGLASCL6                               90
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
     C                   MOVEL     'CGD1214'     CGMSID
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C     KKEY01        READE     CGLASCL6                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXSCL6        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRYOL2   : Process CGLAYOL2                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     C*****SRYOL2        BEGSR                                                             MD054955
      **********                                                                           MD054955
      ***Set*up*subroutine stack name                                                      MD054955
      **********                                                                           MD054955
     C**********         ADD       1             Q                 5 0                     MD054955
     C**********         MOVEL     'SRYOL2'      @STK(Q)                                   MD054955
      **********                                                                           MD054955
     C**********         Z-ADD     1             I#NUMR                                    MD054955
      **********                                                                           MD054955
     C*****KKEY01        SETLL     CGLAYOL2                                                MD054955
     C*****KKEY01        READE     CGLAYOL2                               90               MD054955
      **********                                                                           MD054955
     C******IN90         DOWEQ     *OFF                                         B1         MD054955
     C*****I#NUMR        ANDLT     11                                                      MD054955
      **********                                                                           MD054955
      **If*record found set return code to CGD1202, and send message.                      MD054955
      **********                                                                           MD054955
     C**********         MOVEL     'CGD1202'     W0RTN                                     MD054955
      **********                                                                           MD054955
      ***Set*up*message details.                                                           MD054955
      **********                                                                           MD054955
     C**********         MOVEL     'CGD1215'     CGMSID                                    MD054955
     C**********         MOVEL     LYLAYO        CGMSDT                                    MD054955
     C**********         MOVEL     I#CPGM        CGPGMQ                                    MD054955
     C**********         EXSR      CGSNMS                                                  MD054955
      **********                                                                           MD054955
     C*****KKEY01        READE     CGLAYOL2                               90               MD054955
     C**********         ADD       1             I#NUMR                                    MD054955
     C**********         ENDDO                                                  E          MD054955
      **********                                                                           MD054955
     C*****EXYOL2        TAG                                                               MD054955
     C**********         MOVEA     *BLANKS       @STK(Q)                                   MD054955
     C**********         SUB       1             Q                                         MD054955
      **********                                                                           MD054955
     C**********         ENDSR                                                             MD054955
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
      *COPY*CGCPYSRC,SRERRC                                                                 MD054955
     C/COPY CGCPYSRC,SRERRCLE                                                               MD054955
**CTDATA CPY@
(c) Finastra International Limited 2001
