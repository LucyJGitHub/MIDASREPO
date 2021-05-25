     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Ref Integrity Check: Counterparty Nostro')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0140 - Referential Integrity Check                         *
     F*  CGCORRL5 - Correspondent details by counterparty nostro      *
     F*                                                               *
     F*  Function:  This program tests the first 10 records and if    *
     F*             any exist the return code will be set to 'CGD1182'*
     F*                                                               *
     F*  Called By:                                                   *
     F*                                                               *
      *  (c) Finastra International Limited 2001                      *
     F*                                                               *
      *  Last Amend No. MD056543           Date 15Sep20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD053             Date 01Jun06               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 S01522             Date 21Nov94               *
      *                                    Date ddmmmyy               *
     F*                                                               *
     F*---------------------------------------------------------------*
     F*                                                               *
      *  MD056543 - EDWH SSRS Reports cannot be run.                  *
      *           - Translate graphic fields of CGCORRPD and CGCDSHPD *
      *             to readable unicode equivalent.                   *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD053 - Correspondence Manager Multilanguage Upgrade        *
      *           (Recompile)                                         *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *           (Recompile)                                         *
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
     F/COPY WNCPYSRC,CG0140DFPG
      *
      *  /Copy point for File Definition
      *
     FCGCORRL5  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Correspondent Details By counterparty nostro
      *
     F/EJECT
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY CGCPYSRC,SRERRDLE                                                               MD056543
     D/COPY WNCPYSRC,CG0140DEPG
      *
      *  /Copy point for Arrays
      *
     D/COPY WNCPYSRC,CG0140DIPG
      *
      *  /Copy point for Input Specs
      *
     D CPYR@#          DS
      *
      *  Data structure for compilation  - Copyright insertion
      *
     D  CPY@                   1     80
     D                                     DIM(1) CTDATA PERRCD(1)
     D*COPY*CGCPYSRC,SRERRI                                                                 MD056543
     D RUNDTA        E DS                  EXTNAME(RUNDAT)
      *
      *  Define rundat data area
      *
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
     C                   PARM                    I#CPNC            8            Ctr party Ns
     C                   PARM                    I#CPGM           10            Calling Pgm tr.
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     I/COPY WNCPYSRC,CG0140C
      *
      * Check if Counter party nostro exists on CGCORRL5.
      *
     C                   EXSR      SRRRL5
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
      *  SRRRL5   : Process CGCORRL5                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRRRL5        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRRRL5'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     I#CPNC        SETLL     CGCORRL5
     C     I#CPNC        READE     CGCORRL5                               90
      *
     C     *IN90         DOWEQ     *OFF                                         B1
     C     I#NUMR        ANDLT     11
      *
      * If record found set return code to CGD1182, and send message.
      *
     C                   MOVEL     'CGD1182'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1244'     CGMSID
     C                   MOVEL     CDCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C     I#CPNC        READE     CGCORRL5                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXRRL5        TAG
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
      *
      *  Unwind subroutine stack name
      *
     C     EXINIT        TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     CSR                 ENDSR
     C/EJECT
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C*COPY*CGCPYSRC,SCGSNMSC                                                               MD056543
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/COPY CGCPYSRC,SCGSNMSCLE                                                             MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
**CTDATA CPY@
(c) Finastra International Limited 2001
