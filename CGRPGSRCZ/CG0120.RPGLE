     H DEBUG
     H CCSID(*GRAPH:*SRC)                                                                   MD056543
      *****************************************************************
/*S*DF***RPGBASE*******************************************************                       CSD053
/*S*D ***RPGBNOCVT*****************************************************              CSD053 MD056543
/*E*S ***RPGCVTOPT1****************************************************              CSD053 MD056543
/*STD *  RPGBASEBND                                                   *                     MD056543
/*EXI *  TEXT('Midas CG Ref Integrity Check: Customer')
/*OVRF*: OVRDBF (File in program) (file on system)                  : *
     F*****************************************************************
     F*                                                               *
     F*  Midas - User Defined Correspondence                      *
     F*                                                               *
     F*  CG0120 - Referential Integrity Check                         *
     F*    CGCORRL4 Correspondent details by customer                 *
     F*                                                               *
     F*  Function:  This program tests the first 10 records and if    *
     F*             any exist the return code will be set to 'CGD1183'*
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
      *         - (Recompile)                                         *
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
     F/COPY WNCPYSRC,CG0120DFPG
      *
      *  /Copy point for File Definition
      *
     FCGCORRL4  IF   E           K DISK
     F                                     INFSR(SRFILE)
      *
      * Correspondent Details By customer.
      *
     F/EJECT
     D/COPY CGCPYSRC,SRERRDLE
     D/COPY WNCPYSRC,CG0120DEPG
      *
      *  /Copy point for Arrays
      *
      **                                                                                      CSC022
      ** Array to hold commitment jobs name                                                   CSC022
      **                                                                                      CSC022
     D WCMT            S             10    DIM(10)                                            CSC022
      **                                                                                      CSC022
     D*COPY*CGCPYSRC,SRERRE                                                                 MD056543
     D/COPY WNCPYSRC,CG0120DIPG                                                             MD056543
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
      **                                                                                      CSC022
     D SCCMT           DS           256                                                       CSC022
     D  WCMTNO                 1      3  0                                                    CSC022
     D  WCJOBS                 4    103                                                       CSC022
      ** Commitment Control dataarea                                                          CSC022
      **                                                                                      CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
      ** DS for Switchable Features details                                                   CSC022
      **                                                                                      CSC022
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CSC022
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
     C                   PARM                    I#CUST            6            Cust number
     C                   PARM                    I#CPGM           10            Calling Pgm tr.
      *
      * Initialise program
      *
     C     *IN50         IFEQ      '0'
     C                   EXSR      SRINIT
     C                   END
      *
     I/COPY WNCPYSRC,CG0120C
      *
      * Check if Customer details exist on CGCORRL4.
      *
     C                   EXSR      SRRRL4
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
      *  SRRRL4   : Process CGCORRL4                                  *
      *                                                               *
      *  CALLED BY: Main processing                                   *
      *                                                               *
      *  CALLS    : None                                              *
      *                                                               *
      *****************************************************************
     CSR   SRRRL4        BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRRRL4'      @STK(Q)
      *
     C                   Z-ADD     1             I#NUMR
      *
     C     I#CUST        SETLL     CGCORRL4
     C     I#CUST        READE     CGCORRL4                               90
      *
     C     *IN90         DOWEQ     *OFF                                         B1
     C     I#NUMR        ANDLT     11
      *
      * If record found set return code to CGD1183, and send message.
      *
     C                   MOVEL     'CGD1183'     W0RTN
      *
      *  Set up message details.
      *
     C                   MOVEL     'CGD1239'     CGMSID
     C                   MOVEL     CDCORR        CGMSDT
     C                   MOVEL     I#CPGM        CGPGMQ
     C                   EXSR      CGSNMS
      *
     C     I#CUST        READE     CGCORRL4                               90
     C                   ADD       1             I#NUMR
     C                   ENDDO                                                  E
      *
     C     EXRRL4        TAG
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
     C                   MOVE      'N'           CSC022            1                          CSC022
     C                   MOVE      'N'           WCMTSK            1                          CSC022
      **                                                                                      CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      ** is switched on                                                                       CSC022
      **                                                                                      CSC022
     C                   CALL      'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       P@RTCD            7                          CSC022
     C                   PARM      '*VERIFY '    P@OPTN            7                          CSC022
     C                   PARM      'CSC022'      P@SARD            6                          CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
     C     P@RTCD        IFEQ      *BLANKS                                                    CSC022
     C                   MOVE      'Y'           CSC022                                       CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C     *DTAARA       DEFINE    SCCMTJOB      SCCMT                                        CSC022
     C                   IN        SCCMT                                                      CSC022
      **                                                                                      CSC022
     C     WCMTNO        IFGT      0                                                          CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MOVEA     WCJOBS        WCMT                                         CSC022
      ** Verify if job running exists in array                                                CSC022
     C     ##JOB         LOOKUP    WCMT                                   50                  CSC022
     C     *IN50         IFEQ      *ON                                                        CSC022
     C                   MOVE      'Y'           WCMTSK                                       CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ELSE                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C     P@RTCD        IFNE      '*NRF'                                                     CSC022
     C                   MOVEL     'CSC022'      W0KEY                                        CSC022
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CSC022
     C                   Z-ADD     5             W0ERNB                                       CSC022
     C                   EXSR      SRERR                                                      CSC022
     C                   ENDIF                                                                CSC022
      **                                                                                      CSC022
     C                   ENDIF                                                                CSC022
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
     C*COPY*CGCPYSRC,SRERRPSSR                                                              MD056543
     C*COPY*CGCPYSRC,SCGSNMSC                                                               MD056543
     C*COPY*CGCPYSRC,SRERRC                                                                 MD056543
     C/COPY CGCPYSRC,SRERRPSSRL                                                             MD056543
     C/COPY CGCPYSRC,SCGSNMSCLE                                                             MD056543
     C/COPY CGCPYSRC,SRERRCLE                                                               MD056543
**CTDATA CPY@
(c) Finastra International Limited 2001
