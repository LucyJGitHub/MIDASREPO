     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Utility to populate front office ID in GLCOLAPD')      *
      *****************************************************************
      *                                                               *
      *  Midas - FC Module                                            *
      *                                                               *
      *  SMU00225 - Utility to populate blank front office            *
      *             transaction ID in file GLCOLAPD                   *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 BUG28101 *CREATE   Date 06Sep10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG28101 - Error in component GOC01000 00066                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators                                            *
      *                                                               *
      *    80 - Indicator is set ON if on UPDATE Mode, OFF if on      *
      *         Audit Mode                                            *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
 
      ** Midas GL Collateral Allocation Update Index
 
     FGLCOLAL0  UF   E           K DISK    INFSR(*PSSR)
 
      ** Update Report - Audit
 
     FSMU00225AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
 
      ** Update Report - Detail
 
     FSMU00225P1O    E             PRINTER USROPN
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
 
      ** File Information Data Structure for SMU00225AU
 
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** File Information Data Structure for SMU00225P1
 
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D WkFRNT          DS            20
     D WkConstant              1      7    INZ('MIGCOLA')
     D WkRefNo                 8     16S 0 INZ(0)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D WRUN            S              1
     D WkInit          S              1A
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
 
     D POPTN           S              7A
     D PRTCD           S              7A
     D PMode           S              1A
 
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
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do the Detail Processing              *
      *                                                               *
      *****************************************************************
     C     SRPROC        BEGSR
 
     C                   IF        PMode = 'U' or PMode = 'u'
     C                   EVAL      *IN80 = *ON
     C                   ELSE
     C                   EVAL      *IN80 = *OFF
     C                   ENDIF
 
      **  Update Collateral allocation details only if the front
      **  office transaction ID is blank
 
     C                   READ      GLCOLAL0
 
      ** If no records were read, execute SRAUDIT to report that
      ** there are no details to report, otherwise, register the
      ** printer file
 
     C                   IF        %EOF(GLCOLAL0)
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   DOW       NOT %EOF(GLCOLAL0)
     C                   IF        CAFRNT = *BLANKS
     C                   IF        WkInit = *BLANK
     C                   EVAL      WkInit = 'Y'
     C                   OPEN      SMU00225P1
     C                   WRITE     HEADPY
     C                   ENDIF
     C                   EVAL      R1CNT = R1CNT + 1
     C                   EVAL      WkRefNo = WkRefNo + 1
     C                   EXSR      SRWrtDet
     C   80              EVAL      CAFRNT = WkFRNT
     C   80              UPDATE    GLCOLAD0
     C                   ENDIF
 
     C                   READ      GLCOLAL0
 
     C                   ENDDO
 
     C                   IF        R1CNT = *ZERO
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
      ** Write End of Report
 
     C                   IF        %OPEN(SMU00225P1)
     C                   EXSR      SRChkHdr
     C                   EXSR      SRWrtEnd
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtDet
      *****************************************************************
      *                                                               *
      *  SRWrtDet - Subroutine to write Details                       *
      *                                                               *
      *****************************************************************
     C     SRWrtDet      BEGSR
 
     C                   EVAL      WRQDLN = 2
     C                   EXSR      SRChkHdr
 
      ** Move details
 
     C                   EVAL      RCREF = CACREF
     C                   EVAL      RBRCA = CABRCA
     C                   EVAL      RCNUM = CACNUM
     C   80              EVAL      RFRNT = WkFRNT
 
      ** Write out Detail Block 1
 
     C                   WRITE     DETAIL1
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWrtEnd
      *****************************************************************
      *                                                               *
      *  SRWrtEnd - Subroutine to Write End of Report                 *
      *                                                               *
      *****************************************************************
     C     SRWrtEnd      BEGSR
 
     C                   EVAL      WRQDLN = 3
     C                   EXSR      SRChkHdr
 
      ** Write out Total Format
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRChkHdr
      *****************************************************************
      *                                                               *
      *  SRChkHdr - Subroutine to check if sufficient lines remain    *
      *             else, write out the Main Headings on a new page   *
      *                                                               *
      *****************************************************************
     C     SRChkHdr      BEGSR
 
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
 
     C                   IF        R1CNT = 0
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   WRITE     ENDRPT
 
     C                   IF        %OPEN(SMU00225P1)
     C                   CLOSE     SMU00225P1
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
 
