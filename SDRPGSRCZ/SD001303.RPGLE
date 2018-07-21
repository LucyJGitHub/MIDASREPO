     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2013')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Default Reporting Information')               *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD001303 - Midas SD Default Reporting Information Report     *
      *                                                               *
      *  Function:  This program will produce the following:          *
      *                                                               *
      *             Input Cycle - Generate list report                *
      *             COB         - Generate audit report               *
      *                                                               *
      *  Called By: SDC001303 SD Default Reporting Information Report *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2013            *
      *                                                               *
      *  Last Amend No. CSW216             Date 14Mar16               *
      *  Prev Amend No. MD027768           Date 25Nov14               *
      *                 CSW214             Date 25Nov14               *
      *                 MD022342           Date 12Sep13               *
      *                 MD022703           Date 04Oct13               *
      *                 MD022406           Date 16Sep13               *
      *                 MD021665           Date 09Aug13               *
      *                 CSW213  *CREATE    Date 03Jun13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  MD027768 - Duplicate Clearing Threshold field is displayed   *
      *             on Default Reporting Information Report - Full    *
      *             List                                              *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  MD022342 - No full and audit list report generated during    *
      *             COB.                                              *
      *  MD022703 - Underlying Product ID appears in the report as    *
      *             5 characters only (Recompile)                     *
      *  MD022406 - Incomplete Reporting Id Details in SD001303P1     *
      *             Reporting Information Report                      *
      *  MD021665 - System Level Report is blank. Default PrEnt to    *
      *             'ALL'.                                            *
      *  CSW213 - SWIFT Changes 2013                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                    FUNCTION OF INDICATORS                     *
      *                    **********************                     *
      *                                                               *
      *   13  - FX deal indicator                                     *
      *   14  - FRAIRS deal indicator                                 *
      *   80  - End of File SDRPIFL2                                  *
      *                                                               *
      * U7+U8 - Database Error                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *                      SUBROUTINE INDEX                         *
      *                      ****************                         *
      *                                                               *
      *  *Inzsr        - Program initialisation routine               *
      *  SrProc        - Detail processing                            *
      *  SrPrint       - Print detail record                          *
      *  SrFooter      - Write end of report                          *
      *  SrAudit       - Output audit report and end pgm              *
      *  SrRCFa        - Register SD001303AU via RCF                  *
      *  SrRCFp        - Register SD001303P1 via RCF                  *
      *  SrGetCusDtl   - Retrieve customer details                    *
      *  SrScrnClr     - Initialise detail screen                     *
      *  SrGetScrn     - Retrieve detail screen details               *
      *  SrTerm        - Terminate program                            *
      *  SrCntRec      - Count inserted/amended/deleted records       *
      *  SrCvtDate     - Convert date from file format to screen      *
      *                  format                                       *
      *  *Pssr         - Program exception error routine              *
      *                                                               *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Midas SD Standard Reporting Information by branch
     FSDRPIFL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRPIFD0:SDRPIFP2)
 
      ** Midas SD Standard Reporting Information by recid
     FSDRPIFL3  UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDRPIFD0:SDRPIFP3)
 
      ** Midas SD Customer Extension SWIFT Details File
     FSDCSSWL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Deal type/sub-type file
     FFDDTSTL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD Default Reporting Information Report - List
     FSD001303P1O    E             PRINTER INFDS(SPOOL1)
     F                                     INFSR(*PSSR)
     F                                     USROPN
 
      ** Midas SD Default Reporting Information Report - Audit
     FSD001303AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
     F                                     USROPN
 
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** Midas SD Rundate dataarea layout file
     D RUNDT         E DS            13    EXTNAME(RUNDAT)
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Account Code Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D  BBDFAC2      E                     EXTFLD(QQDFAC)                                     CSW213
 
      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Currency Code Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for Deal Type/Sub-type Details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for Midas Module Details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Customer Extension SWIFT Details
     D SDCSSW        E DS                  EXTNAME(SDCSSWPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D DSLDY         E DS                  EXTNAME(DSLDY)
 
      ** FX deal type array
     D FXDLAr          S              2A   DIM(9) CTDATA PERRCD(1)
     D FXDLDes         S             30A   DIM(9) ALT(FXDLAr)
 
      ** FRA/IRS deal type array
     D FRAIRSAr        S              2A   DIM(6) CTDATA PERRCD(1)
     D FRAIRSDes       S             30A   DIM(6) ALT(FRAIRSAr)
 
      ** Externally described DS for user id
     D ZMUSER          DS            17
     D  WUSRID                 1     10
 
      ** File Information Data Structure for SD001303P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for SD001303AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
 
      ** Parameters for ZSFILE
     D PrSeq           S              5
     D PrEnt           S              3
     D ZsErr           S              1
     D ZsNum           S              6  0
     D ZsNumu          S              6  0
 
      ** Parameters ZDATE2
     D PZDayNo         S              5  0
     D PZDate          S              6  0
     D PZADate         S              7
 
      ** Other working variables
     D Pcust           S             10
     D Pkyst           S              7
     D PvBrch          S              3
     D WwRun           S              1
     D PMode           S              1
     D PRtCd           S              7
     D POptn           S              7
     D ZField          S             16
     D ZDecimal        S              1  0
     D WStr            S              5  0
     D WLen            S              5  0
     D Widx            S              2  0
     D RqdLn1          S              3  0
     D DifLn1          S              4  0
     D Xrow            S              1  0
     D Ycol            S              1  0
     D IADRec          S              5  0                                                  MD022342
     D CSW214          S              1                                                       CSW214
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
 
      ** Main Program
 
     C                   IF        Pmode = 'L'
 
      ** Perform detail processing
 
     C                   EXSR      SrProc
     C                   ELSE
 
      ** Output audit report and end program.
 
     C                   EXSR      SrAudList                                                MD022342
     C                   EXSR      SrAudit
 
      ** After generating audit report, delete all records with
      ** RECID = '*' selected by SDRPIFL3
 
     C                   EXSR      SrDltRec
     C                   ENDIF
 
      ** Perform termination processing
 
     C                   EXSR      SrTerm
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrProc   - Detail processing                                 *
      *                                                               *
      *****************************************************************
     C     SrProc        BEGSR
 
     C**********         WRITE     R1HD                                                     MD022342
 
      ** Access records from the standard reporting information by branch
      ** file PF/SDRPIFPD via the logical file SDRPIFL2
      ** If passed value for entity is equal to 'ALL'
                                                                                            MD021665
     C                   IF        PrEnt = *BLANKS                                          MD021665
     C                   EVAL      PrEnt = 'ALL'                                            MD021665
     C                   ENDIF                                                              MD021665
 
     C                   IF        PrEnt = 'ALL'
     C     *LOVAL        SETLL     SDRPIFL2
     C                   READ      SDRPIFL2                               80
 
     C                   IF        *IN80 = *OFF                                             MD022342
     C                   OPEN      SD001303P1                                               MD022342
     C                   WRITE     R1HD                                                     MD022342
     C                   ENDIF                                                              MD022342
                                                                                            MD023342
     C                   DOW       *IN80 = *OFF
 
     C                   IF        PvBrch <> *BLANKS
     C                   IF        RPBRCH <> PvBrch
     C                   CLOSE     SD001303P1                                               MD022342
     C                   OPEN      SD001303P1                                               MD022342
     C                   EXSR      SrRCFp
     C                   ENDIF
     C                   ENDIF
 
     C**********         EXSR      SrCntRec                                                 MD022342
     C                   EXSR      SrPrint                                                  MD022342
 
     C                   EVAL      PvBrch = RPBRCH
 
     C                   READ      SDRPIFL2                               80
     C                   ENDDO
 
     C                   EXSR      SrFooter                                                 MD022342
     C                   CLOSE     SD001303P1                                               MD022342
                                                                                            MD022342
     C                   ELSE
 
      ** If passed value for entity is equal to a particular branch
 
     C     PrEnt         SETLL     SDRPIFL2
     C     PrEnt         READE     SDRPIFL2
     C                   IF        NOT %EOF(SDRPIFL2)                                       MD022342
     C                   OPEN      SD001303P1                                               MD022342
     C                   WRITE     R1HD                                                     MD022342
     C                   ENDIF                                                              MD022342
     C                   DOW       NOT %EOF(SDRPIFL2)
     C**********         EXSR      SrCntRec                                                 MD022342
     C                   EXSR      SrPrint                                                  MD022342
     C     PrEnt         READE     SDRPIFL2
     C                   ENDDO
     C                   EXSR      SrFooter                                                 MD022342
     C                   CLOSE     SD001303P1                                               MD022342
 
     C                   ENDIF
 
      ***End*of*file*reached,*write*footer*****************************                     MD022342
      **********                                                                            MD022342
     C**********         EXSR      SrFooter                                                 MD022342
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnClr - Clear detail screen fields                       *
      *                                                               *
      *****************************************************************
     C     SrScrnClr     BEGSR
 
     C                   EVAL      R1BRCA = *BLANKS
     C                   EVAL      R1LCD  = *ZERO
     C                   EVAL      R1TYPE = *BLANKS
     C                   EVAL      R1STYP = *BLANKS
     C                   EVAL      R1CPTY = *BLANKS
     C                   EVAL      R1CPNM = *BLANKS
     C                   EVAL      R1CPCT = *BLANKS
     C                   EVAL      R1CPSI = *BLANKS
     C                   EVAL      R1CPLE = *BLANKS
     C                   EVAL      R1CCY  = *BLANKS
     C                   EVAL      R1CCYN = *BLANKS
     C                   EVAL      R1PMIN = *BLANKS
     C                   EVAL      R1RPID = *BLANKS
     C                   EVAL      R1RPNM = *BLANKS
     C                   EVAL      R1RPCT = *BLANKS
     C                   EVAL      R1RPSI = *BLANKS
     C                   EVAL      R1RPJR = *BLANKS
     C                   EVAL      R1REID = *BLANKS
     C                   EVAL      R1RENM = *BLANKS
     C                   EVAL      R1RECT = *BLANKS
     C                   EVAL      R1RESI = *BLANKS
     C                   EVAL      R1RELE = *BLANKS
     C                   EVAL      R1REPI = *BLANKS
     C                   EVAL      R1GTRF = *BLANKS
     C                   EVAL      R1CLTH = *BLANKS
     C                   EVAL      R1CLCY = *BLANKS
     C                   EVAL      R1CCID = *BLANKS
     C                   EVAL      R1CCNM = *BLANKS
     C                   EVAL      R1CCCT = *BLANKS
     C                   EVAL      R1CCSI = *BLANKS
     C                   EVAL      R1CCLE = *BLANKS
     C                   EVAL      R1CCPI = *BLANKS
     C                   EVAL      R1CEID = *BLANKS
     C                   EVAL      R1CENM = *BLANKS
     C                   EVAL      R1CECT = *BLANKS
     C                   EVAL      R1CESI = *BLANKS
     C                   EVAL      R1CELE = *BLANKS
     C                   EVAL      R1CEPI = *BLANKS
     C                   EVAL      R1CBID = *BLANKS
     C                   EVAL      R1CBIC = *BLANKS
     C                   EVAL      R1CPID = *BLANKS
     C                   EVAL      R1EXCV = *BLANKS
     C**********         EVAL      R1CTAM = *BLANKS                                         MD027768
     C**********         EVAL      R1CTAD = *BLANKS                                         MD027768
     C                   EVAL      R1ALIN = *BLANKS
     C                   EVAL      R1CLIN = *BLANKS
     C                   EVAL      R1UPID = *BLANKS
     C                   EVAL      R1NSFL = *BLANKS
     C                   EVAL      R1GETD = *BLANKS
     C                   EVAL      R1GETU = *BLANKS
     C                   EVAL      R1AD01 = *BLANKS
     C                   EVAL      R1AD02 = *BLANKS
     C                   EVAL      R1AD03 = *BLANKS
     C                   EVAL      R1AD04 = *BLANKS
     C                   EVAL      R1AD05 = *BLANKS
     C                   EVAL      R1AD06 = *BLANKS
     C                   EVAL      R1AD07 = *BLANKS
     C                   EVAL      R1AD08 = *BLANKS
     C                   EVAL      R1AD09 = *BLANKS
     C                   EVAL      R1AD10 = *BLANKS
     C                   EVAL      R1AD11 = *BLANKS
     C                   EVAL      R1AD12 = *BLANKS
     C                   EVAL      R1AD13 = *BLANKS
     C                   EVAL      R1AD14 = *BLANKS
     C                   EVAL      R1AD15 = *BLANKS
     C                   EVAL      R1AD16 = *BLANKS
     C                   EVAL      R1AD17 = *BLANKS
     C                   EVAL      R1AD18 = *BLANKS
     C                   EVAL      R1AD19 = *BLANKS
     C                   EVAL      R1AD20 = *BLANKS
 
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R1CBRI = *BLANKS                                           CSW214
     C                   EVAL      R1CBNM = *BLANKS                                           CSW214
     C                   EVAL      R1CBTN = *BLANKS                                           CSW214
     C                   EVAL      R1CBSW = *BLANKS                                           CSW214
     C                   EVAL      R1CBLC = *BLANKS                                           CSW214
     C                   EVAL      R1CBRA = *BLANKS                                           CSW214
     C                   EVAL      R1FNCI = *BLANKS                                           CSW214
     C                   EVAL      R1COPI = *BLANKS                                           CSW214
     C                   EVAL      R1COPC = *BLANKS                                           CSW214
     C                   EVAL      R1POCI = *BLANKS                                           CSW214
     C                   EVAL      R1COSI = *BLANKS                                           CSW214
     C                   EVAL      R1TNEI = *BLANKS                                           CSW214
     C                   EVAL      R1IGTI = *BLANKS                                           CSW214
     C                   EVAL      R1CTFI = *BLANKS                                           CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrPrint  - Print detail record                               *
      *                                                               *
      *****************************************************************
     C     SrPrint       BEGSR
 
      ** Check for overflow
 
     C                   EVAL      RqdLn1 = 28
     C                   EXSR      SrChkLin
 
      ** Populate the output fields
 
     C                   EXSR      SrScrnClr
     C                   EXSR      SrGetScrn
 
      ** Wrte details
 
     C                   WRITE     R1DTL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFooter - Write end of report                               *
      *                                                               *
      *****************************************************************
     C     SrFooter      BEGSR
 
      ** Check that sufficient lines remain for the format. If not,
      ** write out the Main Headings on a new page
 
      ** Write footer
 
     C                   IF        PMode = 'A' AND IADRec = 0                               MD022342
     C                   WRITE     NODETL                                                   MD022342
     C                   ELSE                                                               MD022342
     C                   WRITE     FOOTER
     C                   ENDIF                                                              MD022342
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                MD022342
      *****************************************************************                     MD022342
      *                                                               *                     MD022342
      *  SrAudList - Output audit list report                         *                     MD022342
      *                                                               *                     MD022342
      *****************************************************************                     MD022342
     C     SrAudList     BEGSR                                                              MD022342
                                                                                            MD022342
     C                   OPEN      SD001303P1                                               MD022342
     C                   WRITE     R1HD                                                     MD022342
     C     *LOVAL        SETLL     SDRPIFL2                                                 MD022342
     C                   READ      SDRPIFL2                               80                MD022342
                                                                                            MD022342
     C                   DOW       *IN80 = *OFF                                             MD022342
     C                   ADD       1             AUCROD                                     MD022342
     C                   IF        RPLCD = BJRDNB                                           MD022342
     C                   EXSR      SrCntRec                                                 MD022342
     C                   EXSR      SrPrint                                                  MD022342
     C                   ADD       1             IADRec                                     MD022342
     C                   ENDIF                                                              MD022342
     C                   READ      SDRPIFL2                               80                MD022342
     C                   ENDDO                                                              MD022342
     C                   EXSR      SrFooter                                                 MD022342
     C                   CLOSE     SD001303P1                                               MD022342
                                                                                            MD022342
     C                   ENDSR                                                              MD022342
      *****************************************************************                     MD022342
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit  - Output audit report and end program               *
      *                                                               *
      *****************************************************************
     C     SrAudit       BEGSR
 
     C                   OPEN      SD001303AU
 
      ** Output Report Header
 
     C                   WRITE     AUHEAD
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
 
     C                   WRITE     AUDBER
 
     C                   ELSE
 
      ** if there is a record read, write audit details
 
     C                   IF        AUCROD <> 0
 
     C                   WRITE     AUDETL
 
      ** Or, if no records read, output "No Details" message
 
     C                   ELSE
 
     C                   WRITE     AUNODT
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   CLOSE     SD001303AU
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFp   - Register SD001303P1 via Report Control Facility   *
      *                                                               *
      *****************************************************************
     C     SrRCFp        BEGSR
 
     C**********         CLOSE     SD001303P1                                               MD022342
     C**********         OPEN      SD001303P1                                               MD022342
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   Z-ADD     SFNUM1        ZsNum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PrSeq
     C                   PARM                    PrEnt
     C                   PARM      'SD001303P1'  SFILE1
     C                   PARM                    ZsNum
     C                   PARM      *BLANKS       ZsErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program
 
     C                   IF        ZsErr = 'Y'
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRCFa   - Register SD001303AU via Report Control Facility   *
      *                                                               *
      *****************************************************************
     C     SrRCFa        BEGSR
 
      ** Ensure audit spool file recorded by RCF.
 
     C                   Z-ADD     SFNUMU        ZSNumU
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PrSeq
     C                   PARM                    PrEnt
     C                   PARM      'SD001303AU'  SFILEU
     C                   PARM                    ZsNumU
     C                   PARM      *BLANK        ZsErr
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** calling program.
 
     C                   IF        ZsErr = 'Y'
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCntRec - Count inserted/amended/deleted records            *
      *                                                               *
      *****************************************************************
     C     SrCntRec      BEGSR
 
      ***Current*records*on*database***********************************                     MD022342
      **********                                                                            MD022342
     C**********         ADD       1             AUCROD                                     MD022342
 
      ** Number of amended records
 
     C                   IF        RPTYLC = 'A'
     C                   ADD       1             AUAMND
     C                   ENDIF
 
      ** Number of deleted records
 
     C                   IF        RPTYLC = 'D'
     C                   ADD       1             AUDELT
     C                   ENDIF
 
      ** Number of inserted records
 
     C                   IF        RPTYLC = 'I'
     C                   ADD       1             AUINSR
     C                   ENDIF
 
      ** Call subroutine to write detail records
 
     C                   EXSR      SrPrint
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDltRec - Delete all records with RECID = '*' by SDRPIFL3   *
      *                                                               *
      *****************************************************************
     C     SrDltRec      BEGSR
 
     C     *LOVAL        SETLL     SDRPIFL3
     C                   READ      SDRPIFL3                               80
     C                   DOW       *IN80 = '*OFF'
     C                   DELETE    SDRPIFL3
     C                   READ      SDRPIFL3                               80
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Pssr    - Program exception error routine                   *
      *             Called automatically if a program error occurs,   *
      *             or directly by the program code using EXSR        *
      *             This subroutine DUMPs the program just once       *
      *                                                               *
      *****************************************************************
     C     *Pssr         BEGSR
 
     C                   IF        WWRun = *BLANK
     C                   EVAL      WWRun = 'Y'
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   DUMP
     C                   EXSR      SrAudit
     C                   RETURN
     C                   ENDIF
 
      ** If *Pssr already run, then just end the program here.
 
     C                   EVAL      *INLR = *ON
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetScrn  - Retrieve detail screen details                  *
      *                                                               *
      *****************************************************************
     C     SrGetScrn     BEGSR
 
      ** Get branch details
 
     C                   EVAL      R1BRCA = RPBRCH
     C                   EVAL      PZDayNo = RPLCD
     C                   EXSR      SRCvtDate
     C                   EVAL      R1LCD = PZDate
 
     C                   IF        R1BRCA = 'ALL'
     C                   EVAL      R1BRCD = 'ALL BRANCHES'
     C                   ELSE
 
     C                   CALL      'AOBRCHR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RPBRCH
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1BRCD = A8BRNM
     C                   ENDIF
     C                   ENDIF
 
      ** Get transaction type details
 
     C                   IF        RPTYPE <> *BLANKS
     C                   Z-ADD     1             Xrow
     C                   Z-ADD     1             Ycol
     C     RPTYPE        LOOKUP    FXDLAr(Xrow)                           13
     C     RPTYPE        LOOKUP    FRAIRSAr(Ycol)                         14
 
     C                   IF        *IN13 = *ON
     C                   EVAL      R1TYPE = FXDLDes(Xrow)
     C                   ENDIF
 
     C                   IF        *IN14 = *ON
     C                   EVAL      R1TYPE = FRAIRSDes(Ycol)
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CSW214
      ** Display Clearing Broker details if Transaction Type is                               CSW214
      ** Foreign Exchange or blank                                                            CSW214
                                                                                              CSW214
     C                   EVAL      *IN16 = *OFF                                               CSW214
     C                   IF        RPTYPE = *BLANKS OR *IN13 = *ON                            CSW214
     C                   EVAL      *IN16 = *ON                                                CSW214
     C                   ENDIF                                                                CSW214
 
      ** Get transaction sub-type details
 
     C                   IF        RPSTPE <> *BLANKS
     C                   CALL      'AODLSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RPSTPE
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1STYP = ASDSTN
     C                   ENDIF
     C                   ENDIF
 
      ** Get counterparty details
 
     C                   EVAL      R1CPTY = RPCUSN
     C                   IF        RPCUSN <> *BLANKS
     C                   EVAL      Pcust = RPCUSN
     C                   EXSR      SrGetCusDtl
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1CPNM = BBCRNM
     C                   EVAL      R1CPCT = BBCRTN
     C                   EVAL      R1CPSI = BBCSID
     C                   EVAL      R1CPLE = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Get currency details
 
     C                   EVAL      R1CCY = RPCURR
     C                   IF        RPCURR <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RPCURR
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1CCYN = A6CYNM
     C                   ENDIF
     C                   ENDIF
 
      ** Get precious metal indicator
 
     C                   EVAL      R1PMIN = RPPMLI
 
      ** Get trade repository details
 
     C                   EVAL      R1RPID = RPTRID
     C                   IF        RPTRID <> *BLANKS
     C                   EVAL      Pcust = RPTRID
     C                   EXSR      SrGetCusDtl
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1RPNM = BBCRNM
     C                   EVAL      R1RPCT = BBCRTN
     C                   EVAL      R1RPSI = BBCSID
     C                   ENDIF
     C                   ENDIF
 
      ** Get CCP house details
 
     C                   EVAL      R1CCID = RPCCPN
     C                   EVAL      R1CCPI = RPCCPA
     C                   IF        RPCCPN <> *BLANKS
     C                   EVAL      Pcust = RPCCPN
     C                   EXSR      SrGetCusDtl
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1CCNM = BBCRNM
     C                   EVAL      R1CCCT = BBCRTN
     C                   EVAL      R1CCSI = BBCSID
     C                   EVAL      R1CCLE = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
      ** Get clearing exception details
 
     C                   EVAL      R1CEID = RPCCPP
     C                   EVAL      R1CEPI = RPCRPA
     C                   IF        RPCCPP <> *BLANKS
     C                   EVAL      Pcust = RPCCPP
     C                   EXSR      SrGetCusDtl
     C                   IF        PRtCd = *BLANKS
     C                   EVAL      R1CENM = BBCRNM
     C                   EVAL      R1CECT = BBCRTN
     C                   EVAL      R1CESI = BBCSID
     C                   EVAL      R1CELE = CSLEIC
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      R1CBID = RPCBCL
     C                   EVAL      R1CBIC = RPCCPL
     C                   EVAL      R1CPID = RPCPID
     C                   EVAL      R1EXCV = RPEXVE
     C                   EVAL      R1UPID = RPUPID
 
      ** Get reporting id details
 
     C                   EVAL      R1RPJR = RPRPJN
     C                   EVAL      R1REID = RPRPPY
     C                   EVAL      R1REPI = RPRPAC
     C                   IF        RPRPPY <> *BLANKS
     C                   EVAL      Pcust = RPRPPY
     C                   EXSR      SrGetCusDtl
     C                   IF        PRtCd = *BLANKS
     C**********         EVAL      R1CCNM = BBCRNM                                          MD022406
     C**********         EVAL      R1CCCT = BBCRTN                                          MD022406
     C**********         EVAL      R1CCSI = BBCSID                                          MD022406
     C**********         EVAL      R1CCLE = CSLEIC                                          MD022406
     C                   EVAL      R1RENM = BBCRNM                                          MD022406
     C                   EVAL      R1RECT = BBCRTN                                          MD022406
     C                   EVAL      R1RESI = BBCSID                                          MD022406
     C                   EVAL      R1RELE = CSLEIC                                          MD022406
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      R1GTRF = RPGTID
 
     C                   IF        RPCTAM <> 0
     C                   MOVEL     *BLANKS       ZField
     C                   MOVE      RPCTAM        ZField
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RPCTCY
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   IF        PRtCd = *BLANKS
     C                   Z-ADD     A6NBDP        ZDecimal
     C                   ENDIF
 
     C                   CALL      'ZEDIT'
     C                   PARM                    ZField
     C                   PARM                    ZDecimal
     C                   MOVE      ZField        R1CLTH
     C                   ELSE
     C                   EVAL      R1CLTH = *BLANKS
     C                   ENDIF
 
     C                   EVAL      R1CLCY = RPCTCY
     C                   EVAL      R1ALIN = RPALIN
     C                   EVAL      R1CLIN = RPCLIN
     C                   EVAL      R1NSFL = RPNSFL
     C                   EVAL      R1GETD = RPEXDE
     C                   EVAL      R1GETU = RPEXTC
     C                   EVAL      R1AD01 = RPAD01
     C                   EVAL      R1AD02 = RPAD02
     C                   EVAL      R1AD03 = RPAD03
     C                   EVAL      R1AD04 = RPAD04
     C                   EVAL      R1AD05 = RPAD05
     C                   EVAL      R1AD06 = RPAD06
     C                   EVAL      R1AD07 = RPAD07
     C                   EVAL      R1AD08 = RPAD08
     C                   EVAL      R1AD09 = RPAD09
     C                   EVAL      R1AD10 = RPAD10
     C                   EVAL      R1AD11 = RPAD11
     C                   EVAL      R1AD12 = RPAD12
     C                   EVAL      R1AD13 = RPAD13
     C                   EVAL      R1AD14 = RPAD14
     C                   EVAL      R1AD15 = RPAD15
     C                   EVAL      R1AD16 = RPAD16
     C                   EVAL      R1AD17 = RPAD17
     C                   EVAL      R1AD18 = RPAD18
     C                   EVAL      R1AD19 = RPAD19
     C                   EVAL      R1AD20 = RPAD20
 
     C                   IF        CSW214 = 'Y'                                               CSW214
     C                   EVAL      R1CBRI = RPCBRI                                            CSW214
     C                   EVAL      R1CBRA = RPCBRA                                            CSW214
                                                                                              CSW214
     C                   IF        RPCBRI <> *BLANKS                                          CSW214
     C                   EVAL      Pcust = RPCBRI                                             CSW214
     C                   EXSR      SrGetCusDtl                                                CSW214
                                                                                              CSW214
     C                   IF        PRtCd = *BLANKS                                            CSW214
     C                   EVAL      R1CBNM = BBCRNM                                            CSW214
     C                   EVAL      R1CBTN = BBCRTN                                            CSW214
     C                   EVAL      R1CBSW = BBCSID                                            CSW214
     C                   EVAL      R1CBLC = CSLEIC                                            CSW214
     C                   ENDIF                                                                CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   EVAL      R1FNCI = RPFNCI                                            CSW214
     C                   EVAL      R1COPI = RPCOPI                                            CSW214
     C                   EVAL      R1COPC = RPCOPC                                            CSW214
     C                   EVAL      R1POCI = RPPOCI                                            CSW214
     C                   EVAL      R1COSI = RPCOSI                                            CSW214
     C                   EVAL      R1TNEI = RPTNEI                                            CSW214
     C                   EVAL      R1IGTI = RPIGTI                                            CSW214
     C                   EVAL      R1CTFI = RPCTFI                                            CSW214
     C                   ENDIF                                                                CSW214
                                                                                              CSW214
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrGetCusDtl - Retrieve Customer Details                      *
      *                                                               *
      *****************************************************************
     C     SrGetCusDtl   BEGSR
 
     C                   CLEAR                   DSLDY
 
     C                   CALL      'AOCSSWR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    Pcust
     C                   PARM                    Pkyst
     C                   PARM                    DSLDY
 
     C                   EVAL      WStr = %LEN(SDCUST) + 1
     C                   EVAL      WLen = %LEN(SDCSSW)
     C                   EVAL      SDCUST = DSLDY
     C                   EVAL      SDCSSW = %SUBST(DSLDY:WStr:WLen)
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtDate - Convert date from file format to screen format   *
      *                                                               *
      *****************************************************************
     C     SrCvtDate     BEGSR
 
      ** Call ZDATE2 to convert date from Midas Day number format to
      ** DDMMYY format.
 
     C                   CALL      'ZDATE2'
     C                   PARM                    PZDayno
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrChkLin - Checks for printer file overflow condition        *
      *                                                               *
      *****************************************************************
     C     SrChkLin      BEGSR
 
     C                   EVAL      DifLn1 = OFLLN1 - PRTLN1
 
     C                   IF        DifLn1 <= RqdLn1
     C                   WRITE     R1HD
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *Inzsr     - Program initialisation routine                  *
      *                                                               *
      *****************************************************************
     C     *Inzsr        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PMode
     C                   PARM                    PrSeq
     C                   PARM                    PrEnt
 
     C                   EVAL      R1USER = WUSRID
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD001303  '
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SD001303'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY  = POptn
     C                   EVAL      DBPGM  = 'SD001303'
     C                   EVAL      DBASE  = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** RCF processing for printer file.
 
     C                   EXSR      SrRCFp
 
      ** RCF processing for audit file.
 
     C                   EXSR      SrRCFa
 
      ** Report work fields.
 
     C                   Z-ADD     0             Widx
 
      ** Initialise working fields
 
     C                   Z-ADD     *ZERO         AUINSR
     C                   Z-ADD     *ZERO         AUAMND
     C                   Z-ADD     *ZERO         AUDELT
     C                   Z-ADD     *ZERO         AUCROD
     C                   EVAL      PvBrch = *BLANKS
     C                   EVAL      RqdLn1 = *ZERO
     C                   EVAL      DifLn1 = *ZERO
     C                   EVAL      PRTLN1 = *ZERO
     C                   EVAL      IADRec = 0                                               MD022342
 
      ** Setup report titles.
 
     C                   IF        PMode = 'A'
     C                   EVAL      AUTITL = 'AUDIT List'
     C                   EVAL      R1TITL = 'AUDIT List'
 
     C                   ELSE
 
     C                   EVAL      R1TITL = 'FULL List'
     C                   EVAL      AUTITL = 'FULL List'
 
     C                   ENDIF
                                                                                              CSW214
      ** Check if SWIFT 2014 is installed                                                     CSW214
                                                                                              CSW214
     C                   CALL      'SWIF2014'                                                 CSW214
     C                   PARM      *BLANKS       PRtCd                                        CSW214
                                                                                              CSW214
     C                   EVAL      CSW214 = 'N'                                               CSW214
     C                   EVAL      *IN15 = *OFF                                               CSW214
                                                                                              CSW214
     C                   IF        PRtCd = 'CSW2014'                                          CSW214
     C                   EVAL      CSW214 = 'Y'                                               CSW214
     C                   EVAL      *IN15 = *ON                                                CSW214
     C                   ENDIF                                                                CSW214
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTerm   - Terminate program                                 *
      *                                                               *
      *****************************************************************
     C     SrTerm        BEGSR
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDSR
      *****************************************************************
** FXDLAr
FXALL FX TRANSACTION TYPES
FPPURCHASE
FSSALE
CXCROSS DEAL
PIPURCHASE COVERING INTEREST
SISALE COVERING INTEREST
OPOPTION
OTOPTION TAKE DOWN
SWSWAP
** FRAIRSAr
FRFORWARD RATE AGREEMENT
RSINTEREST RATE SWAP - SINGLE CURRENCY
RXINTEREST RATE SWAP - CROSS - CURRENCY
RPINTEREST RATE CAP
RRINTEREST RATE COLLAR
RFINTEREST RATE FLOOR
