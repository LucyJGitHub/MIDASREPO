     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2012')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('MIDAS LE Merge PDCL Postings into GELEPD')             *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000472 - Merge PDCL Postings into GELEPD                   *
      *                                                               *
      *  Function:  This program will copy all CLE134 posting records *
      *             from file GELEPSL1 to GELEPD file.                *
      *                                                               *
      *  Called By: LEC0472                                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2012            *
      *                                                               *
      *  Last Amend No. MD023377           Date 25Apr14               *
      *  Prev Amend No. AR589238           Date 01Aug12               *
      *                 262864             Date 01Aug12               *
      *                 CLE134  *CREATE    Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD023377  - APOSTPD file has wrong source of posting (SPOS)  *
      *  AR589238  - Suspense postings should not refer to irrelevant *
      *              Loans.                                           *
      *              (Child: AR589239B)                               *
      *            - Process GELEPSL2 as well as GELEPSL1.            *
      *              (Child: AR589239A)                               *
      *            - Unknown movement on 1961-suspense account        *
      *              Avoid generation of unnecessary postings to      *
      *              balance OL repayments moved to PDCL.             *
      *              (Child: AR589239)                                *
      *  262864 - Ignore records with RECI = '*'                      *
      *  CLE134 - Past Due Call Loan Processing                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    98         Date Format                                     *
      *    U7+U8      Database Errors                                 *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise Subroutine                                *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ! F-specs                              !
      ** ! =======                              !
      ** +--------------------------------------+
 
     FGELEPSL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(APOSTPDF:APOSTF)
      ** Postings file
     FGELEPSL2  IF   E           K DISK    INFSR(*PSSR)                                     AR589238
     F                                     RENAME(APOSTPDF:APOST2)                          AR589238
      ** Postings file                                                                      AR589238
     FLEGELEL1  IF   E           K DISK    INFSR(*PSSR)                                     AR589238
     F                                     RENAME(APOSTPDF:APOSTLE)                         AR589238
     F                                     PREFIX(I_)                                       AR589238
 
     FGELEPD    O    E             DISK    INFSR(*PSSR) COMMIT
     F                                     RENAME(APOSTPDF:GELEP)
      ** MIDAS Postings
 
     FGELEZZ    UF   E             DISK    INFSR(*PSSR) COMMIT
      ** MIDAS Postings Trailer
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ! D-specs                              !
      ** ! =======                              !
      ** +--------------------------------------+
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      ** 134 141 DBFILE
      ** Defines:                     142 170 DBKEY
      ** 171 180 DBPGM
      ** 181 1830DBASE
 
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** General Ledger Details                                                             AR589238
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                AR589238
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                                AR589238
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                                AR589238
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                AR589238
     D  QQDFACS      E                     EXTFLD(QQDFAC)                                   AR589238
     D CGPNAR        E DS                  EXTNAME(CGPNARPD)                                AR589238
     D SDACOD        E DS                  EXTNAME(SDACODPD)                                AR589238
     D  QQACCDS      E                     EXTFLD(QQACCD)                                   AR589238
     D DSSDY         E DS                  EXTNAME(DSSDY)                                   AR589238
     D DSFDY         E DS                  EXTNAME(DSFDY)                                   AR589238
      ** +--------------------------------------+
      ** ! Named constants                      !
      ** ! ===============                      !
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ! Arrays and Data Structures           !
      ** ! ==========================           !
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ! Declared variables                   !
      ** ! ==================                   !
      ** +--------------------------------------+
 
     D##CLIM           S             18A   Inz('CUS LEND IMBALANCE')                        AR589238
     D  WNSUS          DS                                                                   AR589238
     D  WNNAR                  1     18                                                     AR589238
     D  WNBRC                 20     22                                                     AR589238
     D  WNCCY                 26     28                                                     AR589238
     DWrkCntRec        S              7  0 Inz(0)
      ** Work - Record Count
 
     DWrkPstTtl        S             18  0 Inz(0)
      ** Work - Total Posting Amount
 
     DWrkHshTtl        S             18  0 Inz(0)
      ** Work - Hash Total
 
     D @RUN            S              1
      ** Work variable used in *PSSR
                                                                                            AR589238
      ** Access Object Parameters                                                           AR589238
     D PRTCD           S              7A                                                    AR589238
     D POPTN           S              7A                                                    AR589238
     D PSARD           S              6A                                                    AR589238
     D PCUST           S             10A                                                    AR589238
     D PCURR           S              3A                                                    AR589238
     D PKYST           S              7A                                                    AR589238
     D PACOD           S                   LIKE(A5ACCD)                                     AR589238
     D PZRTCD          S              7A                                                    AR589238
     D PZMGID          S              7A                                                    AR589238
     D PZPARM          S              9A                                                    AR589238
     D PZNARR          S             50A                                                    AR589238
     D PZPNAR          S                   LIKE(CGPNAR)                                     AR589238
                                                                                            AR589238
      ** Additional Field Definitions
     D WCRTOT          S             21  0
     D WDRTOT          S             21  0
     D WBRCA           S              3
     D WCCY            S              3
     D LEPNAR          S              1
     D BALSUS          S             15  0
     D WDRCR           S              1  0
 
      ** +--- Start of Main processing -------------------------------+
      ** |                                                            |
      ** | Initial processing is performed automatically: the *INZSR  |
      ** | executed at program activation.                            |
      ** |                                                            |
      ** +------------------------------------------------------------+
 
      ** Read in Installation Data
 
     C     *DTAARA       DEFINE                  RUNDAT
     C     *DTAARA       DEFINE                  LDA
     C                   IN        RUNDAT
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Read a Record from postings file
 
     C                   READ      GELEPSL1
 
     C                   DOW       NOT %EOF(GELEPSL1)
                                                                                              262864
      ** do not process deleted postings                                                      262864
                                                                                              262864
     C                   IF        RECI = 'P'                                                 262864
 
      ** Write in MIDAS Postings - GELEPD
 
     C                   WRITE     GELEP
 
     C                   EVAL      WRKCNTREC = WRKCNTREC + 1
     C                   EVAL      WRKPSTTTL = WRKPSTTTL + PSTA
     C                   ENDIF                                                                262864
 
      ** Read Next Record from postings file
 
     C                   READ      GELEPSL1
 
     C                   ENDDO
 
      ** Read a Record from second postings file                                            AR589238
                                                                                            AR589238
     C                   READ      GELEPSL2                                                 AR589238
                                                                                            AR589238
     C                   DOW       NOT %EOF(GELEPSL2)                                       AR589238
                                                                                            AR589238
      ** do not process deleted postings                                                    AR589238
                                                                                            AR589238
     C                   IF        RECI = 'P'                                               AR589238
                                                                                            AR589238
      ** Write in MIDAS Postings - GELEPD                                                   AR589238
                                                                                            AR589238
     C                   WRITE     GELEP                                                    AR589238
                                                                                            AR589238
     C                   EVAL      WRKCNTREC = WRKCNTREC + 1                                AR589238
     C                   EVAL      WRKPSTTTL = WRKPSTTTL + PSTA                             AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Read Next Record from second postings file                                         AR589238
                                                                                            AR589238
     C                   READ      GELEPSL2                                                 AR589238
                                                                                            AR589238
     C                   ENDDO                                                              AR589238
                                                                                            AR589238
      ** Calculate debit/credit for each branch/ccy and                                     AR589238
      ** generate suspens postings if they don't balance.                                   AR589238
      ** Read a Record from postings file                                                   AR589238
                                                                                            AR589238
     C                   Z-ADD     *ZEROS        WCRTOT                                     AR589238
     C                   Z-ADD     *ZEROS        WDRTOT                                     AR589238
     C                   MOVE      *BLANKS       WBRCA                                      AR589238
     C                   MOVE      *BLANKS       WCCY                                       AR589238
                                                                                            AR589238
     C                   READ      LEGELEL1                                                 AR589238
                                                                                            AR589238
     C                   DOW       NOT %EOF(LEGELEL1)                                       AR589238
     C                   IF        I_RECI = 'P'                                             AR589238
                                                                                            AR589238
      ** If change of branch and/or ccy then check                                          AR589238
      ** if suspense posting is needed                                                      AR589238
                                                                                            AR589238
     C                   IF        I_BRCA <> WBRCA AND WBRCA <> *BLANKS AND                 AR589238
     C                             I_BRCA >= WBRCA OR                                       AR589238
     C                             I_CCY <> WCCY AND WCCY <> *BLANKS AND                    AR589238
     C                             I_BRCA >=WBRCA                                           AR589238
     C                   IF        WCRTOT <> WDRTOT                                         AR589238
                                                                                            AR589238
      ** Create suspense account posting                                                    AR589238
                                                                                            AR589238
     C                   EXSR      GENSUSP                                                  AR589238
                                                                                            AR589238
      ** Set work field                                                                     AR589238
                                                                                            AR589238
     C                   EVAL      WDRTOT = 0                                               AR589238
     C                   EVAL      WCRTOT = 0                                               AR589238
     C                   ENDIF                                                              AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Maintain cr/dr total                                                               AR589238
                                                                                            AR589238
     C                   IF        I_DRCR = 0                                               AR589238
     C                   EVAL      WDRTOT = WDRTOT + I_PSTA                                 AR589238
     C                   ELSE                                                               AR589238
     C                   EVAL      WCRTOT = WCRTOT + I_PSTA                                 AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** save branch and ccy                                                                AR589238
                                                                                            AR589238
     C                   EVAL      WBRCA = I_BRCA                                           AR589238
     C                   EVAL      WCCY = I_CCY                                             AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
     C                   READ      LEGELEL1                                                 AR589238
                                                                                            AR589238
     C                   ENDDO                                                              AR589238
                                                                                            AR589238
      ** check DR/CR of last branc/ccy processed                                            AR589238
                                                                                            AR589238
     C                   IF        WCRTOT <> WDRTOT                                         AR589238
     C                   EXSR      GENSUSP                                                  AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Set the pointer to the top of the file
                                                                                            AR589238
     C     0001          SETLL     GELEZZ
 
      ** Read the file GELEZZ
 
     C                   READ      GELEZZ
 
     C                   IF        %EOF(GELEZZ)
 
      ** No record present in file GELEZZ
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'GELEZZ'
     C                   EVAL      DBASE = 001
     C                   EVAL      DBKEY = '*FIRST'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
      ** Update the field values of GELEZZ file
 
     C                   EVAL      WRKCNTREC = WRKCNTREC + NORE1
     C                   MOVE      WRKCNTREC     NORE1
 
     C                   EVAL      WRKHSHTTL = (HRWN * 1000) + HRDC
     C                   EVAL      WRKHSHTTL = WRKHSHTTL + WRKPSTTTL
 
     C                   MOVEL     WRKHSHTTL     HRWN
     C                   MOVE      WRKHSHTTL     HRDC
 
      ** Update GELEZZ file
 
     C                   UPDATE    APOSTZZF
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Initializing the LDA information
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   EVAL      DBPGM = 'LE0472'
     C                   OUT       LDA
                                                                                            AR589238
      ** Access General Ledger Details                                                      AR589238
                                                                                            AR589238
     C                   CALL      'AOGELRR1'                                               AR589238
     C                   PARM      '       '     PRTCD                                      AR589238
     C                   PARM      '*FIRST '     POPTN                                      AR589238
     C     SDGELR        PARM      SDGELR        DSSDY                                      AR589238
                                                                                            AR589238
     C     PRTCD         IFNE      *BLANKS                                                  AR589238
     C                   MOVEL     'SDGELRPD'    DBFILE                                     AR589238
     C                   EVAL      DBASE = 901                                              AR589238
     C                   MOVEL     '*FIRST  '    DBKEY                                      AR589238
     C                   EXSR      *PSSR                                                    AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
     C                   CALL      'AOACODR0'                                               AR589238
     C                   PARM      *BLANKS       PRTCD                                      AR589238
     C                   PARM      '*KEY   '     POPTN                                      AR589238
     C                   PARM                    BKACCD                                     AR589238
     C     SDACOD        PARM      SDACOD        DSSDY                                      AR589238
                                                                                            AR589238
     C                   IF        PRTCD <> *BLANKS                                         AR589238
     C                   EVAL      DBFILE = 'SDACODPD'                                      AR589238
     C                   EVAL      DBKEY = BKACCD                                           AR589238
     C                   EVAL      DBASE = 902                                              AR589238
     C                   EXSR      *PSSR                                                    AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Check for presence of feature LEPNAR                                               AR589238
                                                                                            AR589238
     C                   MOVE      'N'           LEPNAR                                     AR589238
     C                   CALL      'AOSARDR0'                                               AR589238
     C                   PARM      *BLANKS       PRTCD                                      AR589238
     C                   PARM      '*VERIFY'     POPTN                                      AR589238
     C                   PARM      'LEPNAR'      PSARD                                      AR589238
                                                                                            AR589238
     C                   IF        PRTCD = *BLANKS                                          AR589238
     C                   EVAL      LEPNAR = 'Y'                                             AR589238
     C                   ELSE                                                               AR589238
     C                   EVAL      LEPNAR = 'N'                                             AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Access bank details.                                                               AR589238
                                                                                            AR589238
     C                   CALL      'AOBANKR0'                                               AR589238
     C                   PARM      *BLANKS       PRTCD                                      AR589238
     C                   PARM      '*FIRST '     POPTN                                      AR589238
     C     SDBANK        PARM      SDBANK        DSFDY                                      AR589238
                                                                                            AR589238
     C                   IF        PRTCD <> *BLANKS                                         AR589238
     C     *LOCK         IN        LDA                                                      AR589238
     C                   EVAL      DBFILE = 'SDBANKPD'                                      AR589238
     C                   EVAL      DBKEY = POPTN                                            AR589238
     C                   EVAL      DBASE = 903                                              AR589238
     C                   OUT       LDA                                                      AR589238
     C                   EXSR      *PSSR                                                    AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
     C                   ENDSR                                                              AR589238
      *****************************************************************                     AR589238
      /EJECT                                                                                AR589238
      *****************************************************************                     AR589238
      *                                                               *                     AR589238
      *  GenSusp - Create suspense account posting                    *                     AR589238
      *                                                               *                     AR589238
      *****************************************************************                     AR589238
                                                                                            AR589238
     C     GENSUSP       BEGSR                                                              AR589238
                                                                                            AR589238
      ** get branch details                                                                 AR589238
                                                                                            AR589238
     C                   EXSR      GETBRCA                                                  AR589238
                                                                                            AR589238
      ** get narrative                                                                      AR589238
                                                                                            AR589238
     C                   EVAL      WNNAR = ##CLIM                                           AR589238
     C                   EVAL      WNBRC = WBRCA                                            AR589238
     C                   EVAL      WNCCY = WCCY                                             AR589238
     C                   EVAL      PZNARR = WNSUS                                           AR589238
     C                   IF        LEPNAR = 'Y'                                             AR589238
     C                   EXSR      GETPNAR                                                  AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
     C                   Z-ADD     0             BALSUS                                     AR589238
     C                   Z-ADD     0             WDRCR                                      AR589238
                                                                                            AR589238
     C                   IF        WCRTOT < WDRTOT                                          AR589238
     C                   EVAL      BALSUS = WDRTOT - WCRTOT                                 AR589238
     C                   Z-ADD     1             WDRCR                                      AR589238
     C                   ELSE                                                               AR589238
     C                   EVAL      BALSUS = WCRTOT - WDRTOT                                 AR589238
     C                   Z-ADD     0             WDRCR                                      AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
      ** Set fields                                                                         AR589238
                                                                                            AR589238
     C                   CLEAR                   APOSTPDF                                   AR589238
     C                   EVAL      RECI = 'P'                                               AR589238
     C                   EVAL      CNUM = A8BICN                                            AR589238
     C                   EVAL      CCY = WCCY                                               AR589238
     C                   EVAL      ACSQ = 01                                                AR589238
     C                   EVAL      PSTD = BJRDNB                                            AR589238
     C                   EVAL      VALD = BJRDNB                                            AR589238
     C                   EVAL      PNAR = PZNARR                                            AR589238
     C                   EVAL      PSTA = BALSUS                                            AR589238
     C                   EVAL      DRCR = WDRCR                                             AR589238
     C                   EVAL      ASOC = *BLANKS                                           AR589238
     C                   EVAL      CHQN = *ZEROS                                            AR589238
     C**********         EVAL      SPOS = ' GE-LE'                                 AR589238 MD023377
     C                   EVAL      SPOS = '  GE-LE'                                         MD023377
     C                   EVAL      BRCA = WBRCA                                             AR589238
     C                   IF        A5ACTY = 'R'                                             AR589238
     C                   EVAL      RIND = 1                                                 AR589238
     C                   ENDIF                                                              AR589238
     C                   EVAL      ATYP = A5ACTY                                            AR589238
                                                                                            AR589238
     C                   EVAL      ATYP = A5ACTY                                            AR589238
     C                   BITOFF    '01234567'    PRIN                                       AR589238
     C                   EVAL      GETP = 'U'                                               AR589238
     C                   EVAL      PTIM = 235959                                            AR589238
     C                   EVAL      ACSC = A5ACSC                                            AR589238
     C                   EVAL      BOKC = I_BOKC                                            AR589238
     C                   MOVE      BKACCD        ACOD                                       AR589238
     C                   EVAL      SWCR = *BLANKS                                           AR589238
     C                   EVAL      DLREF = *BLANKS                                          AR589238
     C                   EVAL      DBCNUM = *ZEROS                                          AR589238
     C                   EVAL      OTST = *BLANKS                                           AR589238
     C                   EVAL      OTTP = *BLANKS                                           AR589238
     C                   EVAL      OTRF = *BLANKS                                           AR589238
     C                   WRITE     GELEP                                                    AR589238
                                                                                            AR589238
      ** Add total rec/value                                                                AR589238
                                                                                            AR589238
     C                   EVAL      WRKCNTREC = WRKCNTREC + 1                                AR589238
     C                   EVAL      WRKPSTTTL = WRKPSTTTL + PSTA                             AR589238
                                                                                            AR589238
     C                   ENDSR                                                              AR589238
      *****************************************************************                     AR589238
      /EJECT                                                                                AR589238
      *****************************************************************                     AR589238
      *                                                               *                     AR589238
      *  GETBRCA - Get Branch                                         *                     AR589238
      *                                                               *                     AR589238
      *****************************************************************                     AR589238
     C     GETBRCA       BEGSR                                                              AR589238
                                                                                            AR589238
     C                   CALL      'AOBRCHR1'                                               AR589238
     C                   PARM      '*DBERR'      PRTCD                                      AR589238
     C                   PARM      '*KEY'        POPTN                                      AR589238
     C                   PARM                    WBRCA                                      AR589238
     C     SDBRCH        PARM                    DSSDY                                      AR589238
                                                                                            AR589238
                                                                                            AR589238
     C                   CALL      'AOCUSTR0'                                               AR589238
     C                   PARM      *BLANKS       PRTCD                                      AR589238
     C                   PARM      '*KEY   '     POPTN                                      AR589238
     C                   PARM      A8BICN        PCUST                                      AR589238
     C                   PARM      *BLANKS       PKYST                                      AR589238
     C     SDCUST        PARM      SDCUST        DSSDY                                      AR589238
                                                                                            AR589238
     C                   IF        PRTCD <> *BLANKS                                         AR589238
     C     *LOCK         IN        LDA                                                      AR589238
     C                   EVAL      DBFILE = 'SDCUSTPD'                                      AR589238
     C                   EVAL      DBKEY = PCUST                                            AR589238
     C                   EVAL      DBASE = 904                                              AR589238
     C                   OUT       LDA                                                      AR589238
     C                   EXSR      *PSSR                                                    AR589238
     C                   ENDIF                                                              AR589238
 
     C                   ENDSR                                                              AR589238
      *****************************************************************                     AR589238
      /EJECT                                                                                AR589238
      *****************************************************************                     AR589238
      *                                                               *                     AR589238
      *  GETPNAR - Get   PNAR                                         *                     AR589238
      *                                                               *                     AR589238
      *****************************************************************                     AR589238
     C     GETPNAR       BEGSR                                                              AR589238
                                                                                            AR589238
     C                   CLEAR                   CGPNAR                                     AR589238
     C                   EVAL      MNTRNO = *ZEROS                                          AR589238
     C                   EVAL      MNMODI = 'LE'                                            AR589238
     C                   EVAL      MNCUST = A8BICN                                          AR589238
     C                   EVAL      MNBRCA = WBRCA                                           AR589238
     C                   EVAL      MNCYCD = WCCY                                            AR589238
     C                   EVAL      MNACCD = BKACCD                                          AR589238
     C                   EVAL      MNACSQ = '01'                                            AR589238
     C                   EVAL      MNCRNM = BBCRNM                                          AR589238
     C                   EVAL      MNRACN= *ZEROS                                           AR589238
     C                   EVAL      MNNARR = PZNARR                                          AR589238
     C                   EVAL      PZMGID = 'GB00010'                                       AR589238
                                                                                            AR589238
     C                   CALL      'AOPNARR0'                                               AR589238
     C                   PARM      *BLANKS       PZRTCD                                     AR589238
     C                   PARM                    PZMGID                                     AR589238
     C                   PARM      *BLANKS       PZPARM                                     AR589238
     C     CGPNAR        PARM      CGPNAR        PZPNAR                                     AR589238
     C                   PARM      *BLANKS       PZNARR                                     AR589238
                                                                                            AR589238
     C                   IF        PZRTCD <> *BLANKS                                        AR589238
     C     *LOCK         IN        LDA                                                      AR589238
     C                   EVAL      DBFILE = 'CGPNARPD'                                      AR589238
     C                   EVAL      DBKEY = MNCUST                                           AR589238
     C                   EVAL      DBASE = 905                                              AR589238
     C                   OUT       LDA                                                      AR589238
     C                   EXSR      *PSSR                                                    AR589238
     C                   ENDIF                                                              AR589238
                                                                                            AR589238
     C                   ENDSR                                                              AR589238
      *****************************************************************                     AR589238
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
      *****************************************************************
      /EJECT
