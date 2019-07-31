     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Wipe Out request record for DL0410/DL0411')   *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS100007 - Wipe out any on request record for DL0410         *
      *             and DL0411 when switching CAS001 on               *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 224165  *CREATE    Date 07Jan04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  224165 - Wipe any on-request record for DL0410 and DL0411    *
      *           when switching CAS001 on                            *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FFCPREQL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas FC Periodic Requests Update index
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Standing Data Controls
 
     FFCPARPL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas FC Parameters(Periodic) Update index
 
     FFCRREQL1  UF   E           K DISK    INFSR(*PSSR)
      ** Midas FC Report Requests Requests by Rep/Seq
 
     FFCPARDL0  UF   E           K DISK    INFSR(*PSSR)
      ** Midas FC Parameters(daily)    Update index
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     D LDA           E DS           256    DTAARA(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Array containing the report names
     D WReport         S             10A   DIM(2) CTDATA
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D X               S              1  0
     D WCounter        S              3  0
     D WRprtName       S             10A
     D WRun            S              1A
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
     C                   EVAL      WCounter = 0
     C                   EVAL      X = 1
     C                   DOW       X < 3
 
      ** Wipe out the all the request for the reports in array WReport
 
     C     WReport(X)    SETLL     FCPREQL0
     C     WReport(X)    READE     FCPREQL0                               01
     C                   DOW       *IN01 = *OFF
     C                   DELETE    FCPREQL0
     C                   EVAL      WCounter = WCounter + 1
     C     WReport(X)    READE     FCPREQL0                               01
     C                   ENDDO
 
     C     WReport(X)    SETLL     FCPARPL0
     C     WReport(X)    READE     FCPARPL0                               01
     C                   DOW       *IN01 = *OFF
     C                   DELETE    FCPARPL0
     C     WReport(X)    READE     FCPARPL0                               01
     C                   ENDDO
 
     C     WReport(X)    SETLL     FCRREQL1
     C     WReport(X)    READE     FCRREQL1                               01
     C                   DOW       *IN01 = *OFF
     C                   DELETE    FCRREQL1
     C     WReport(X)    READE     FCRREQL1                               01
     C                   ENDDO
 
     C     WReport(X)    SETLL     FCPARDL0
     C     WReport(X)    READE     FCPARDL0                               01
     C                   DOW       *IN01 = *OFF
     C                   DELETE    FCPARDL0
     C     WReport(X)    READE     FCPARDL0                               01
     C                   ENDDO
 
      ** Check for next report name
 
     C                   EVAL      X = X + 1
     C                   ENDDO
 
      ** Update the record FCPREQPD for Midas SD Standing Data Controls
 
     C                   IF        WCounter > 0
     C                   EVAL      WRprtName = 'FCPREQPD  '
     C     WRprtName     CHAIN     SDFCTLL0
     C                   IF        %FOUND(SDFCTLL0)
     C                   EVAL      AHNORC = AHNORC - WCounter
     C                   EVAL      AHNODL = AHNODL + WCounter
     C                   UPDATE    @AHREAU
     C                   ELSE
     C                   EVAL      DBFILE = 'SDFCTLL0'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = WRprtName
     C                   EVAL      DBPGM = 'AS100007'
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      *********************************************************************
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      ********************************************************************
** Report Names
DL0410
DL0411
