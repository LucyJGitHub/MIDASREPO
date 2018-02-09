     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2010')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas GL Account Transfer Housekeeping')               *
      *****************************************************************
      *                                                               *
      *  Midas - General Ledger Module                                *
      *                                                               *
      *  GL003000 - GL Account Transfer Housekeeping                  *
      *                                                               *
      *  Function:  This program will purge all records in Account    *
      *             Transfer Manual Input file                        *
      *                                                               *
      *  Called By: GLC003000 - Account Transfer Housekeeping         *
      *                                                               *
      *  (c) Finastra International Limited 2010                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR1075388          Date 21Nov13               *
      *                 CGL127             Date 06Aug12               *
      *                 AR845655           Date 06Oct11               *
      *                 CRE067             Date 05Oct10               *
      *                 BUG27831A          Date 05Aug10               *
      *                 BUG27832           Date 22Jun10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27389           Date 05Apr10               *
      *                 CAP204  *CREATE    Date 11Jan10               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1075388 - Account transfer fees - net (Child:AR1075389)    *
      *              Applied for MD-23536 (Recompile)                 *
      *  CGL127 - COB Restructuring - GL COB Optimisation Phase 1     *
      *  AR845655 - Update datatype of Paying Bank to Alphanumeric    *
      *             (Recompile)                                       *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  BUG27831A - Forward Account Transfer Processing              *
      *              (Recompiled due to changes in GLATMIPD)          *
      *  BUG27832 - Chicago performance issues: File Locking on       *
      *             T_SEQUENCE. T_SEQUENCE is no longer used and      *
      *             replaced by *DTAARA GLRATMSEQ.                    *
      *  BUG27389 - Executed account transfers should be displayed    *
      *             in the listview                                   *
      *  CAP204 - Retail Account Transfer                             *
      *                                                               *
      *****************************************************************
 
     F***GLATMIL0  UF   E           K DISK    INFSR(*PSSR)                                    CGL127
     FGLATMIL8  UF   E           K DISK    INFSR(*PSSR)                                       CGL127
      ** GL Account Transfer Manual Input File
 
     F***GLHATML1  UF   E           K DISK    INFSR(*PSSR)                           BUG27389 CGL127
     FGLHATML5  UF   E           K DISK    INFSR(*PSSR)                                       CGL127
     F                                     RENAME(GLATMID0:GLATMID1)                        BUG27389
      ** GL Account Transfer Manual Input File - Historic                                   BUG27389
                                                                                            BUG27389
     FGL003000P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
      ** GL Account Transfer Housekeeping Report
 
     FGL003000AUO    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOLU)
      ** GL Account Transfer Housekeeping Report - Audit
 
     F***T_SEQUENCEUF A E           K DISK    INFSR(*PSSR)                                  BUG27832
     F***                                     RENAME(T_SEQUENCE:T_SEQFMT)                   BUG27832
     ***Midas*RE*Sequence*table****************************************                     BUG27832
 
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRInit   - Program Initialisation                            *
      *  SRProces - Detail Processing                                 *
      *  SRPrint  - Process Report Lines                              *
      *  SRAudit  - Produce Audit Report and End Program              *
      *                                                               *
      *  SRWP1REC - Write a Detail Record to the Report               *
      *  SRWP1END - Write End of Report                               *
      *                                                               *
      *  *PSSR    - Program Error Processing Subroutine               *
      *  SRRCFP1  - RCF Processing for P1 Report                      *
      *  SRRCFAU  - RCF Processing for Audit Report                   *
      *                                                               *
      *****************************************************************
     D/EJECT
      ** Array containing Copyright statement
 
      /SPACE 3
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D SPOOL1          DS
      ** File Information Data Structure for GL003000P1
 
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
     D SPOOLU          DS
      ** File Information Data Structure for GL003000AU
 
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External data structures for Bank Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      **  Short data structures for Access Objects
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRtCd           S              7
     D POptn           S              7
     D PSeq            S              5
     D PEnty           S              3
     D PZSErr          S              1
     D PZSNum          S              6  0
     D PSFile          S             10
     D WRun            S              1
     D WRqdln          S              3  0
     D WDifln          S              3  0
     D WRetPrd         S              5
     D WRetPrdN        S              5  0
     D WRetCalc        S              5  0
     D WTranRetPrd     S              5  0
     D W2DBAC          S             10
     D W2DBSQ          S              2
     D W2CRAC          S             10
     D W2CRSQ          S              2
     D K_SeqNam        S             20
     D WMEnd           S              1A                                                    BUG27389
 
     D P@OP01          S             20
     D P@VL01          S            200
     D P@OP02          S             20
     D P@VL02          S            200
     D P@OP03          S             20
     D P@VL03          S            200
     D P@OP04          S             20
     D P@VL04          S            200
     D P@OP05          S             20
     D P@VL05          S            200
     D P@OP06          S             20
     D P@VL06          S            200
     D P@OP07          S             20
     D P@VL07          S            200
     D P@OP08          S             20
     D P@VL08          S            200
     D P@OP09          s             20
     D P@VL09          S            200
     D P@OP10          S             20
     D P@VL10          S            200
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
     C/TITLE Main Processing
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
 
      ** Perform Initialisation
 
     C                   EXSR      SRInit
 
      ** Perform Detail Processing
 
     C                   EXSR      SRProcess
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAudit
 
      *================================================================
      *  P R O G R A M   E N D                                        *
      *================================================================
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Subroutine to do Program Initialisation             *
      *                                                               *
      *****************************************************************
 
     C     SRInit        BEGSR
 
      ** Initialise LDA field
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBMOD = 'GL003000'
     C                   EVAL      DBPGM = 'GL003000'
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details - Title, Run Date and
      ** Run Day Number
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS'     PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = PRtCd
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for System Value - TransferRetenPeriod
 
     C                   EVAL      P@OP01 = 'TransferRetenPeriod'
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM                    P@OP01
     C                   PARM      *BLANKS       P@VL01
     C                   PARM                    P@OP02
     C                   PARM      *BLANKS       P@VL02
     C                   PARM                    P@OP03
     C                   PARM      *BLANKS       P@VL03
     C                   PARM                    P@OP04
     C                   PARM      *BLANKS       P@VL04
     C                   PARM                    P@OP05
     C                   PARM      *BLANKS       P@VL05
     C                   PARM                    P@OP06
     C                   PARM      *BLANKS       P@VL06
     C                   PARM                    P@OP07
     C                   PARM      *BLANKS       P@VL07
     C                   PARM                    P@OP08
     C                   PARM      *BLANKS       P@VL08
     C                   PARM                    P@OP09
     C                   PARM      *BLANKS       P@VL09
     C                   PARM                    P@OP10
     C                   PARM      *BLANKS       P@VL10
 
      ** Handle Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 2
     C                   EVAL      DBFILE = 'SDSVALPD'
     C                   EVAL      DBKEY = P@OP01
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   IF        P@VL01 <> *BLANKS
     C                   EVALR     WRetPrd =  %TRIM(P@VL01)
     C                   ENDIF
     C                   MOVE      WRetPrd       WRetPrdN
     C     WRetPrdN      MULT      31            WTranRetPrd
     C                   ENDIF
 
      ** Report Work fields
 
     C                   EVAL      OFLLN1 = *ZEROS
     C                   EVAL      WDifln = *ZEROS
     C                   EVAL      RCOUNT = *ZEROS
     C                   EVAL      RCOUNT2 = *ZEROS                                         BUG27389
                                                                                              CGL127
      ** Calculate Retention Period                                                           CGL127
                                                                                              CGL127
     C                   EVAL      WRetCalc = BJRDNB - WTranRetPrd                            CGL127
     C                   EVAL      WRetCalc = WRetCalc - 1                                    CGL127
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRProcess
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to do the Detail Processing           *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Read first record from File
 
     C******LOVAL        SETLL     GLATMIL0                                                   CGL127
     C**********         READ      GLATMIL0                                                   CGL127
     C     WRetCalc      SETGT     GLATMIL8                                                   CGL127
     C                   READP     GLATMIL8                                                   CGL127
 
      ** If End of Records, Perform: Audit Reporting (No Records)
 
     C                   EVAL      WMEnd = 'N'                                              BUG27389
     C**********         IF        %EOF(GLATMIL0)                                             CGL127
     C                   IF        %EOF(GLATMIL8)                                             CGL127
     C**********         EXSR      SRAudit                                                  BUG27389
     C                   EVAL      WMEnd = 'Y'                                              BUG27389
     C                   ENDIF
 
     C**********         DOW       NOT %EOF(GLATMIL0)                                         CGL127
     C                   DOW       NOT %EOF(GLATMIL8)                                         CGL127
 
      ** Check if the exec date has fallen beyond the retention period
 
     C**********         EVAL      WRetCalc = R1EXDT + WTranRetPrd                            CGL127
     C**********         IF        WRetCalc < BJRDNB                                          CGL127
 
     C                   EXSR      SRPrint
     C                   DELETE    GLATMID0
 
      ** Count records read
 
     C                   EVAL      RCOUNT = RCOUNT + 1
     C**********         ENDIF                                                                CGL127
 
     C**********         READ      GLATMIL0                                                   CGL127
     C                   READP     GLATMIL8                                                   CGL127
 
      ** End of Do Until End of Valid Records
 
     C                   ENDDO
                                                                                            BUG27389
      ** Read first record from Historic File                                               BUG27389
                                                                                            BUG27389
     C******LOVAL        SETLL     GLHATML1                                          BUG27389 CGL127
     C**********         READ      GLHATML1                                          BUG27389 CGL127
     C     WRetCalc      SETGT     GLHATML5                                                   CGL127
     C                   READP     GLHATML5                                                   CGL127
                                                                                            BUG27389
      ** If End of Records, Perform: Audit Reporting (No Records)                           BUG27389
                                                                                            BUG27389
     C**********         IF        %EOF(GLHATML1) AND WMEnd = 'Y'                    BUG27389 CGL127
     C                   IF        %EOF(GLHATML5) AND WMEnd = 'Y'                             CGL127
     C                   EXSR      SRAudit                                                  BUG27389
     C                   ENDIF                                                              BUG27389
                                                                                            BUG27389
     C**********         DOW       NOT %EOF(GLHATML1)                                BUG27389 CGL127
     C                   DOW       NOT %EOF(GLHATML5)                                         CGL127
                                                                                            BUG27389
      ** Check if the exec date has fallen beyond the retention period                      BUG27389
                                                                                            BUG27389
     C**********         EVAL      WRetCalc = R1EXDT + WTranRetPrd                   BUG27389 CGL127
     C**********         IF        WRetCalc < BJRDNB                                 BUG27389 CGL127
                                                                                            BUG27389
     C                   EXSR      SRPrint                                                  BUG27389
     C                   DELETE    GLATMID1                                                 BUG27389
                                                                                            BUG27389
      ** Count records read                                                                 BUG27389
                                                                                            BUG27389
     C                   EVAL      RCOUNT2 = RCOUNT2 + 1                                    BUG27389
     C**********         ENDIF                                                       BUG27389 CGL127
                                                                                            BUG27389
     C**********         READ      GLHATML1                                          BUG27389 CGL127
     C                   READP     GLHATML5                                                   CGL127
                                                                                            BUG27389
      ** End of Do Until End of Valid Records                                               BUG27389
                                                                                            BUG27389
     C                   ENDDO                                                              BUG27389
 
      ***Reset*to*one*the*daily*incremental*number*in*T_SEQUENCE*******                     BUG27832
 
     C**********         EVAL      K_SeqNam = 'GLATMIPD'                                    BUG27832
     C*****K_SeqNam      CHAIN     T_SEQUENCE                                               BUG27832
     C**********         EVAL      SEQVALUE  = 1                                            BUG27832
     C**********         IF        %FOUND(T_SEQUENCE)                                       BUG27832
     C**********         UPDATE    T_SEQFMT                                                 BUG27832
     C**********         ELSE                                                               BUG27832
     C**********         EVAL      SEQNAME   = 'GLATMIPD'                                   BUG27832
     C**********         WRITE     T_SEQFMT                                                 BUG27832
     C**********         ENDIF                                                              BUG27832
 
      ** Write End of Report
 
     C                   IF        RCOUNT <> *ZEROS
     C                             OR RCOUNT2 <> *ZEROS                                     BUG27389
     C                   EXSR      SRWP1END
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRPrint
      *****************************************************************
      *                                                               *
      *  SRPrint  - Process Report Lines                              *
      *                                                               *
      *****************************************************************
 
     C     SRPrint       BEGSR
 
      ** If first pass or branch is not the same as previous branch
 
     C                   IF        NOT %OPEN(GL003000P1)
     C                   OPEN      GL003000P1
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Do RCF processing
 
     C                   EXSR      SRRCFP1
 
      ** Write Details
      ** Branch, Tran Reference, Trans Type, Trans Subtype
 
     C                   EVAL      RABRCA = R1BRCA
     C                   EVAL      RATREF = R1TREF
     C                   EVAL      RATRTY = R1TRTY
     C                   EVAL      RATRST = R1TRST
 
      ** DB Account
 
     C                   MOVE      R1DBAC        W2DBAC
     C                   MOVE      R1DBSQ        W2DBSQ
     C                   EVAL      RADBAC = R1DBBR + R1DBCU + R1DBCY +
     C                                      W2DBAC + W2DBSQ
 
      ** DB Retail Account, Trans Type
 
     C                   MOVE      R1DBRE        RADBRE
     C                   EVAL      RADRTT = R1DRTT
 
      ** CR Account
 
     C                   MOVE      R1CRAC        W2CRAC
     C                   MOVE      R1CRSQ        W2CRSQ
     C                   EVAL      RACRAC = R1CRBR + R1CRCU + R1CRCY +
     C                                      W2CRAC + W2CRSQ
 
      ** CR Retail Account, Trans Type
 
     C                   MOVE      R1CRRE        RACRRE
     C                   EVAL      RACRTT = R1CRTT
 
     C                   EXSR      SRWP1REC
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRWP1REC
      *****************************************************************
      *                                                               *
      *  SRWP1REC - Subroutine to Write a Detail record to the Report *
      *                                                               *
      *****************************************************************
 
     C     SRWP1REC      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 1
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write out Detail Record
 
     C                   WRITE     DETAIL
 
     C                   ENDSR
      *
      *****************************************************************
      /TITLE SR/SRWP1END
      *****************************************************************
      *                                                               *
      *  SRWP1END - Subroutine to Write End of Report                 *
      *                                                               *
      *****************************************************************
 
     C     SRWP1END      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page
 
     C                   EVAL      WRqdln = 4
     C                   EVAL      WDifln = OFLLN1 - PRTLN1
     C                   IF        WDifln <= WRqdln
     C                   WRITE     HEADPY
     C                   ENDIF
 
      ** Write out Trailer Format
 
     C                   WRITE     TRAILPY
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRAudit
      *****************************************************************
      *                                                               *
      *  SRAudit - Subroutine to Output Audit report and End Program  *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Open Audit Report, Do RCF processing & Print Header
 
     C                   OPEN      GL003000AU
     C                   EXSR      SRRCFAU
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON AND *INU8 = *ON
     C                   WRITE     DBERROR
     C                   WRITE     TRAILAU
     C                   ELSE
 
      ** If no records read, Output "No Details" message
      ** else, write file control format
 
     C                   IF        RCOUNT = *ZEROS
     C                             AND RCOUNT2 = *ZEROS                                     BUG27389
     C                   WRITE     NODTLS
     C                   ELSE
     C                   WRITE     CONTROL
     C                   WRITE     TRAILAU
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   IF        %OPEN(GL003000P1)
     C                   CLOSE     GL003000P1
     C                   ENDIF
     C                   IF        %OPEN(GL003000AU)
     C                   CLOSE     GL003000AU
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      *  *PSSR  - Error control subroutine                            *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   EXSR      SRAudit
     C                   ENDIF
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRRCFP1
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Subroutine to register the P1 Printer File via RCF *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILE1
     C                   Z-ADD     SFNUM1        PZSNum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRRCFAU
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Subroutine to register the AU Printer File via RCF *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   EVAL      PSFile = SFILEU
     C                   EVAL      PZSNum = SFNUMU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    PSFile
     C                   PARM                    PZSNum
     C                   PARM      *BLANK        PZSErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PZSErr = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
