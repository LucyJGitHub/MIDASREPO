     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to delete records from FCPREQL0')              *
      *****************************************************************
      *                                                               *
      *  Midas - FC Module                                            *
      *                                                               *
      *  SMU00216 - Utility to delete selected report name from       *
      *             FCPREQL0 and related files.                       *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. BUG27976           Date 18Aug10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27092 *CREATE   Date 16Mar10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG27976 - Error running SMUC00216 during implementation -   *
      *             upgrading an R4 system to BF                      *
      *  BUG27092 - Utility program to delete a specific report name  *
      *             from FCPREQL0 as well as all related files        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    80 - Indicator is set ON if on DELETE Mode, OFF if on      *
      *         Audit Mode                                            *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
 
      ** Midas FC Periodic Requests
 
     FFCPREQL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas FC Parameters(Periodic) Update Index
 
     FFCPARPL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas MA Archive contents(P) by report/seq
 
     FMAARCPL2  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas SD Standing Data Controls
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas FC Rpt Requests Periodics by Per/Seq
 
     FFCRREQL9  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas FC Parameters(daily)
 
     FFCPARDL0  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Midas MA Archive conts (D) by rept/seq/prt
 
     FMAARCDL2  UF   E           K DISK    INFSR(*PSSR)
     F**********                           COMMIT                                           BUG27976
 
      ** Update Report - Audit
 
     FSMU00216AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Update Report - Detail
 
     FSMU00216P1O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Local data area for database error details
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Program Status Data Structure
 
     D/COPY GPCPYSRCG,PSDS
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for SMU00216AU
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** File Information Data Structure for SMU00216P1
 
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRUN            S              1
     D WDeleteYN       S              1A
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
     D WFILEN          S             10A
 
     D POPTN           S              7A
     D PRTCD           S              7A
     D PMode           S              1A
     D PReport         S             10A
     D PSeqNumber1     S              2A
     D PSeqNumber2     S              5A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /SPACE 3
      *****************************************************************
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Detail Processing
 
     C                   EXSR      SRPROC
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAUDIT
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Subroutine to do Program Initialisation             *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PReport
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBMOD  = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   EVAL      DBPGM  = PSPROCNAME
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = PRTCD
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      RURPT  = BJURPT
     C                   EVAL      RMRDT  = BJMRDT
     C     KRepSeq       KLIST
     C                   KFLD                    PReport
     C                   KFLD                    PSeqNumber1
 
     C     KRepSeq2      KLIST
     C                   KFLD                    PReport
     C                   KFLD                    PSeqNumber2
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing              *
      *                                                               *
      *****************************************************************
 
     C     SRPROC        BEGSR
 
     C                   EVAL      RPRT   = PReport
     C                   IF        PMode = 'D' or PMode = 'd'
     C                   EVAL      *IN80 = *ON
     C                   ELSE
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
 
      **  Delete Periodic Request Record
 
     C     PReport       SETLL     FCPREQL0
     C     PReport       READE     FCPREQL0
 
      ** If no records were read, execute SRAUDIT to report that
      ** there are no details to report, otherwise, register the
      ** printer file
 
     C                   IF        %EOF(FCPREQL0)
     C                   EXSR      SRAUDIT
     C                   ELSE
     C                   OPEN      SMU00216P1
     C                   EVAL      R1RPRT = PReport
     C                   WRITE     HEADPY
     C                   ENDIF
 
     C                   DOW       NOT %EOF(FCPREQL0)
     C                   EVAL      R1CNT = R1CNT + 1
     C                   EXSR      SRWrtOut1
     C                   EVAL      PSeqNumber1 = D9PSQN
     C   80              DELETE    @D9REJI
 
      **  Delete Periodic Request Parameters Record
 
     C     KRepSeq       CHAIN     FCPARPL0
     C                   IF        %FOUND(FCPARPL0)
     C                   EVAL      R2CNT = R2CNT + 1
     C                   EXSR      SRWrtOut2
     C   80              DELETE    @D8REJH
     C                   ENDIF
 
      **  Delete Archive Contents Parameters Record
 
     C     KRepSeq       SETLL     MAARCPL2
     C     KRepSeq       READE     MAARCPL2
 
     C                   IF        NOT %EOF(MAARCPL2)
     C                   EXSR      SRWrtOut3A
     C                   ENDIF
 
     C                   DOW       NOT %EOF(MAARCPL2)
     C                   EVAL      R3CNT = R3CNT + 1
     C                   EXSR      SRWrtOut3B
     C   80              DELETE    @ARCPAP
     C     KRepSeq       READE     MAARCPL2
     C                   ENDDO
 
      **  Update file controls
 
     C                   EVAL      WFileN = 'FCPREQPD'
     C     WFileN        CHAIN     SDFCTLL0
 
      **  Database error if no record found for file
 
     C                   IF        NOT %FOUND(SDFCTLL0)
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLL1'
     C                   EVAL      DBKEY  = 'FCPREQPD'
     C                   EVAL      DBASE  = 2
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Update number of deletions
 
     C   80              ADD       1             AHNODL
     C   80              SUB       1             AHNORC
 
      **  Update file control record
 
     C   80              UPDATE    @AHREAU
 
      **  Delete report request if present
 
     C     KRepSeq       CHAIN     FCRREQL9
 
     C                   IF        %FOUND(FCRREQL9)
     C                   EVAL      R4CNT = R4CNT + 1
     C                   EXSR      SRWrtOut4
     C                   EVAL      PSeqNumber2 = D5RQSQ
     C   80              DELETE    @RREQA8
 
      **  Delete report request parameters if present
 
     C     KRepSeq2      CHAIN     FCPARDL0
     C                   IF        %FOUND(FCPARDL0)
     C                   EVAL      R5CNT = R5CNT + 1
     C                   EXSR      SRWrtOut5
     C   80              DELETE    @D7REJE
     C                   ENDIF
 
     C     KRepSeq2      SETLL     MAARCDL2
 
      **  Delete Periodic request archiving, if present
 
     C     KRepSeq2      READE     MAARCDL2
 
     C                   IF        NOT %EOF(MAARCDL2)
     C                   EXSR      SRWrtOut6A
     C                   ENDIF
 
     C                   DOW       NOT %EOF(MAARCDL2)
     C                   EVAL      R6CNT = R6CNT + 1
     C                   EXSR      SRWrtOut6B
     C   80              DELETE    @ARCDAO
     C     KRepSeq2      READE     MAARCDL2
     C                   ENDDO
 
     C                   END
 
     C     PReport       READE     FCPREQL0
 
     C                   ENDDO
 
      ** Write End of Report
 
     C                   IF        %OPEN(SMU00216P1)
     C                   EXSR      SRCHKHDR
     C                   EXSR      SRWRTP1END
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut1
      *****************************************************************
      *                                                               *
      *  SRWrtOut1 - Subroutine to write Detail 1                     *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut1     BEGSR
 
     C                   EVAL      WRQDLN = 10
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      RD9PSQN   =   D9PSQN
     C                   EVAL      RD9PDSC   =   D9PDSC
     C                   EVAL      RD9FREQ   =   D9FREQ
     C                   EVAL      RD9COTT   =   D9COTT
     C                   EVAL      RD9CSEQ   =   D9CSEQ
 
      ** Write out Detail Block 1
 
     C                   WRITE     OUT1
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut2
      *****************************************************************
      *                                                               *
      *  SRWrtOut2 - Subroutine to write Detail 2                     *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut2     BEGSR
 
     C                   EVAL      WRQDLN = 5
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      RD8PARM   =   D8PARM
 
      ** Write out Detail Block 2
 
     C                   WRITE     OUT2
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut3A
      *****************************************************************
      *                                                               *
      *  SRWrtOut3A - Subroutine to write Detail 3A                   *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut3A    BEGSR
 
     C                   EVAL      WRQDLN = 4
     C                   EXSR      SRCHKHDR
 
      ** Write out Detail Block 3A
 
     C                   WRITE     OUT3A
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut3B
      *****************************************************************
      *                                                               *
      *  SRWrtOut3B - Subroutine to write Detail 3B                   *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut3B    BEGSR
 
     C                   EVAL      WRQDLN = 2
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      RECARID   =   ECARID
     C                   EVAL      RECRSFX   =   ECRSFX
 
      ** Write out Detail Block 3B
 
     C                   WRITE     OUT3B
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut4
      *****************************************************************
      *                                                               *
      *  SRWrtOut4 - Subroutine to write Detail 4                     *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut4     BEGSR
 
     C                   EVAL      WRQDLN = 8
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      RD5RQSQ   =   D5RQSQ
     C                   EVAL      RD5LVL    =   D5LVL
     C                   EVAL      RD5COTT   =   D5COTT
     C                   EVAL      RD5CSEQ   =   D5CSEQ
 
      ** Write out Detail Block 4
 
     C                   WRITE     OUT4
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut5
      *****************************************************************
      *                                                               *
      *  SRWrtOut5 - Subroutine to write Detail 5                     *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut5     BEGSR
 
     C                   EVAL      WRQDLN = 5
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      RD7PARM   =   D7PARM
 
      ** Write out Detail Block 5
 
     C                   WRITE     OUT5
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut6A
      *****************************************************************
      *                                                               *
      *  SRWrtOut6A - Subroutine to write Detail 6A                   *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut6A    BEGSR
 
     C                   EVAL      WRQDLN = 4
     C                   EXSR      SRCHKHDR
 
      ** Write out Detail Block 6A
 
     C                   WRITE     OUT6A
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtOut6B
      *****************************************************************
      *                                                               *
      *  SRWrtOut6B - Subroutine to write Detail 6B                   *
      *                                                               *
      *****************************************************************
 
     C     SRWrtOut6B    BEGSR
 
     C                   EVAL      WRQDLN = 2
     C                   EXSR      SRCHKHDR
 
      ** Move details
 
     C                   EVAL      REBARID   =   EBARID
     C                   EVAL      REBRSFX   =   EBRSFX
 
      ** Write out Detail Block 6B
 
     C                   WRITE     OUT6B
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWRTP1END
      *****************************************************************
      *                                                               *
      *  SRWRTP1END - Subroutine to Write End of Report               *
      *                                                               *
      *****************************************************************
 
     C     SRWRTP1END    BEGSR
 
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRCHKHDR
 
      ** Write out Total Format
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRCHKHDR
      *****************************************************************
      *                                                               *
      *  SRCHKHDR - Subroutine to check if sufficient lines remain    *
      *             else, write out the Main Headings on a new page   *
      *                                                               *
      *****************************************************************
 
     C     SRCHKHDR      BEGSR
 
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
     C                   IF        WDIFLN < WRQDLN
     C                   WRITE     HEADPY
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRAUDIT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON AND
     C                             *INU8 = *ON
 
      ** Write control records if record processed is not zeros
 
     C                   ROLBK
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** If no records read, Output "No Details" message
      ** else, write file control formats
 
     C                   IF        R1CNT = 0 AND
     C                             R2CNT = 0 AND
     C                             R3CNT = 0 AND
     C                             R4CNT = 0 AND
     C                             R5CNT = 0 AND
     C                             R6CNT = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C**********         COMMIT                                                             BUG27976
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   WRITE     ENDRPT
 
     C                   IF        %OPEN(SMU00216P1)
     C                   CLOSE     SMU00216P1
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR - Error control subroutine                             *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      ** Check to see that *PSSR has not already been called
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   RETURN
 
     C                   ENDSR
 
