     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Yield Curves Maintenance')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000741 - Yield Curves Maintenance                          *
      *                                                               *
      *  Function:  This program maintains the Yield Curve            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG14109           Date 05Jun07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9330            Date 11Dec05               *
      *                 CDL038             Date 10May05               *
      *                 228995             Date 10Aug04               *
      *                 228390             Date 14Jul04               *
      *                 CSC022             Date 24Feb04               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG14109 - Timestamp field was not populated                 *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9330 - Change error message USR9267 to USR9500.           *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  228995 - Validate if Yield curves being deleted still have   *
      *           yield rates attached.                               *
      *  228390 - Introduce a new yield curve type 'S' (for swap      *
      *           rates) which will apply the formula currently being *
      *           used by curve type 'Z' and a new formula for type   *
      *           'Z' is to be introduced.                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    03         F3 Exit                                         *
      *    05         F5 Refresh                                      *
      *    09         F9 Add/Change Mode                              *
      *    27         Rollup/Rolldown Key                             *
      *    31         Maintenance/Enquiry Mode                        *
      *    32         Invalid Selection                               *
      *    33         Invalid Yield Curve Name                        *
      *    34         Invalid Yield Curve Description                 *
      *    35         Invalid Yield Curve Type                        *
      *    36         Invalid Interpolation Method                    *
      *    37         Selection Mode                                  *
      *    40         Global Error Indicator                          *
      *    60         READ/CHAIN Indicator                            *
      *    61         READ Indicator                                  *
      *    62         READC Indicator                                 *
      *    70         TESTN Indicator                                 *
      *    78         Protect Yield Curve Name                        *
      *    79         Protect Selection Field                         *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Subfile End (SFLEND)                            *
      *    83         Force Input Format                              *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    86         PUTOVR Indicator                                *
      *    87         Enable Key Screen                               *
      *    89         Add Mode                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR        -  Program Initialisation Routine              *
      *  SRSelect      -  Yield Curve Type Selection                  *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display subfile                             *
      *  SRProcess     -  Process screen input                        *
      *  SRSubfileRec  -  Process modified subfile record             *
      *  SRAction      -  Process subfile record                      *
      *  SRNullRecord  -  Check for null record                       *
      *  SRValidKey    -  Validate subfile record                     *
      *  SRValidate    -  Validate subfile record relations           *
      *  SRUpdate      -  Update records from subfile                 *
      *  SRDetail      -  Process action requested                    *
      *  SRAddReq      -  Process add request                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRUpdReq      -  Process update request                      *
      *  SRTrailer     -  Update Control Files                        *
      *  SRMode        -  Switch between *ADD and *CHANGE modes       *
      *  SRReload      -  Request subfile reload                      *
      *  SRProtect     -  Set display attributes for subfile record   *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Transfer records from SDYLDCL1 to subfile   *
      *  SRWrite       -  Create Yield Curve Details                  *
      *  SRDelete      -  Delete Yield Curve Details                  *
      *  SRAmend       -  Update Yield Curve Details                  *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SREnd         -  End program                                 *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSD000741DFCF   E             WORKSTN USROPN
     F                                     SFILE(SD000741S0:#0RLRN)
     F                                     INFDS(INFDS#)
     F                                     INFSR(*PSSR)
      ** Display file for Yield Curve
 
     FSDYLDCL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(YLDCL0)
     F                                     COMMIT
     F                                     RENAME(SDYLDCD0:@YLDCL0)
      ** Yield Curves Master File Update Index
 
     FSDYLDCL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     USROPN
     F                                     INFDS(YLDCL1)
     F                                     RENAME(SDYLDCD0:@YLDCL1)
      ** Yield Curves Master File Retrieval Index
                                                                                              228995
     FSDYLDRL1  IF   E           K DISK    INFSR(*PSSR)                                       228995
      ** Yield Rates Master File Retrieval Index                                              228995
 
     FGLTRANL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:@TRANL0)
      ** Live Deals and Customer Loans
 
     FGLTRANL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(CLOANCLF:@TRANL1)
      ** Live Deals and Customer Loans
 
     FGLTRANL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:@TRANL2)
      ** Live Deals and Customer Loans
 
     FGLTRANL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDBF:@TRANL3)
      ** Live Deals and Customer Loans
 
     FGLTRANL4  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDCF:@TRANL4)
      ** Live Deals and Customer Loans
 
     FGLTRANL5  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(DEALSDDF:@TRANL5)
      ** Live Deals and Customer Loans
 
     FSDTPSTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:@TPSTL0)
      ** Deal and Loan Type/Sub-Type
 
     FSDTPSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDLOAND0:@TPSTL1)
      ** Deal and Loan Type/Sub-Type
 
     FSDTPSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:@TPSTL2)
      ** Deal and Loan Type/Sub-Type
 
     FSDTPSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FDDTSTPD:@TPSTL3)
      ** Deal and Loan Type/Sub-Type
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Review from fields
     D                 DS
     D  SPOSN                  1      5
     D  #0POS1                 1      5
 
      ** File Information
     D YLDCL0          DS
     D  #YLDC0                 9      9
     D YLDCL1          DS
     D  #YLDC1                 9      9
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current/previous master file format fields for change control
     D @1DBRC        E DS                  EXTNAME(SDYLDCL0)
                                                                                              CSC022
      ** External data structure for SAR details                                              CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
                                                                                              CSC022
      ** Jobs Handling Commitment Control                                                     CSC022
     D SCCMTJOB      E DS           256    EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITARR               4    103                                                       CSC022
                                                                                              CSC022
      ** Array of Commitment Job Names                                                        CSC022
     D COMITJOB        S             10A   DIM(10)                                            CSC022
 
      ** Data Structure for record fields
     D YCRDCS          DS            32
 
      ** Data structure for record selection
     D W_YLDC          DS
     D  W_YLDC1                1      1
     D  W_YLDC2                2      2
     D  W_YLDC3                3      3
     D  W_YLDC4                4      4
     D  W_YLDC5                5      5
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PMODE           S              1
     D PRTCD           S              7
     D POPTN           S              7
     D @RUN            S              1
     D W0RSF           S              1
     D W0PMD           S              3
     D WLRCD           S              4  0
     D WPOSN           S              5
     D CAIN89          S              1
     D CAIN81          S              1
     D WKIPIN          S              1
     D W0NLR           S              1
     D WFNAM           S             10
     D W#EROR          S              1
     D YCRDC           S              1
     D PYLDC           S              5
     D WSLCTR          S              3  0
     D WNODAT          S              1
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D ZADFMF          S             10
     D PZMsgFile       S             10
     D PZMsgID         S             10
     D CPY2@           S             80
     D WQB10X          S             10
     D WQA5N           S              5  0
     D WQC10X          S             10
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WSkipRec        S              1
     D WKeyScrn        S              1
     D WDetScrn        S              1
     D WValid          S              1
     D WQG3N           S              3  0
     D CSC022          S              1A   INZ('N')                                           CSC022
     D CNT             S              3  0                                                    CSC022
     D COMITSKIP       S              1A                                                      CSC022
 
      ** Timestamp for the transaction
     D TimeStamp       S               Z                                                    BUG14109
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      W0RSF = 'N'
 
      ** Display screen until reload requested
 
     C     W0RSF         DOWEQ     'N'
 
      ** Selection Mode while no data on file
 
     C                   IF        PMODE = '?'
     C                   IF        WNODAT = 'Y'
     C                   EXSR      SRSelect
     C                   ENDIF
     C                   ENDIF
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *IN03         CASEQ     '1'           SREnd
 
     C     *IN05         CASEQ     '1'           SRReload
 
     C     *IN27         CASEQ     '1'           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDDO
 
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0 - Access Bank Details                    *
      *             *PSSR                                             *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Set up copyright parameter
 
     C                   MOVEA     CPY@          CPY2@
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
     C                   PARM                    PYLDC
 
      ** Define LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'SD000741'
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY =  *BLANKS
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
 
      ** Obtain default message file
 
     C     *DTAARA       DEFINE    Y2MGFLA       ZADFMF
     C                   IN        ZADFMF
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = POPTN
     C                   EVAL      DBPGM  = 'SD000741'
     C                   EVAL      DBASE  = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       CSC022
      ** Access SAR details file to determine if CSC022 switchable feature                    CSC022
      *  is switched on                                                                       CSC022
     C                   CALLB     'AOSARDR0'                                                 CSC022
     C                   PARM      *BLANKS       @RTCD                                        CSC022
     C                   PARM      '*VERIFY'     @OPTN                                        CSC022
     C                   PARM      'CSC022'      @SARD                                        CSC022
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC022
                                                                                              CSC022
     C                   IF        @RTCD = *Blanks                                            CSC022
                                                                                              CSC022
     C                   EVAL      CSC022 = 'Y'                                               CSC022
     C                   IN        SCCMTJOB                                                   CSC022
     C                   Z-ADD     1             CNT                                          CSC022
     C                   MOVEL     *BLANKS       COMITSKIP                                    CSC022
     C                   MOVEA     COMITARR      COMITJOB                                     CSC022
     C     COMITNUM      IFGT      0                                                          CSC022
     C     CNT           DOWLE     COMITNUM                                                   CSC022
     C     PSJOBNAME     IFEQ      COMITJOB(CNT)                                              CSC022
     C                   MOVEL     'Y'           COMITSKIP                                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ADD       1             CNT                                          CSC022
     C                   ENDDO                                                                CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ELSE                                                                 CSC022
      *                                                                                       CSC022
      ** Database error                                                                       CSC022
      *                                                                                       CSC022
     C                   IF        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 4                                                  CSC022
     C                   OUT       LDA                                                        CSC022
     C                   EXSR      *PSSR                                                      CSC022
     C                   ENDIF                                                                CSC022
                                                                                              CSC022
     C                   ENDIF                                                                CSC022
 
      ** Open files for update
 
     C                   OPEN      SD000741DF
     C     #YLDC0        IFNE      '1'
     C                   OPEN      SDYLDCL0
     C                   ENDIF
     C     #YLDC1        IFNE      '1'
     C                   OPEN      SDYLDCL1
     C                   ENDIF
 
     C                   Z-ADD     14            WSFPG
 
      ** Set to *CHANGE mode
 
     C                   EVAL      W0PMD = 'CHG'
 
      ** Initialise subfile control
 
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #0RUNA = BJMRDT
 
     C                   EVAL      ##PGMQ = PSProcName
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0USER = PSUser
 
      * Initialise subfile control
 
     C                   Z-ADD     *ZERO         #0LCDT
     C                   MOVEL     *BLANK        #0CHTP
     C                   MOVEL     *BLANK        #0POS1
     C                   MOVEL     *BLANK        #0POS2
     C                   MOVEL     *BLANK        #0POS3
     C                   MOVEL     *BLANK        #0POS4
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelect - Yield Curve Type Selection                         *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRSelect      BEGSR
 
      ** Check yield curve if existing
 
     C                   EVAL      #0POS1 = ##YLDC
 
     C     #0POS1        CHAIN     @YLDCL0                            60
 
      ** Record not found
 
     C                   IF        *IN60
     C                   EVAL      PRTCD = '*ERROR '
     C                   EVAL      PYLDC = *BLANKS
     C                   ELSE
     C                   EVAL      PYLDC = FSYLDC
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRLoad, SRZasnms                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = *ON
     C                   WRITE     SD000741C0
     C                   EVAL      *IN80 = *OFF
     C                   EVAL      *IN81 = *OFF
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'N'
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** If CHANGE mode, then position file
 
     C                   IF        W0PMD <> 'ADD'
     C                   EVAL      WPOSN = SPOSN
 
      ** Setup key
 
     C     #0POS1        SETLL     @YLDCL1                            82
 
     C                   READ      @YLDCL1                                82
     C                   ELSE
     C                   EVAL      *IN82 = *OFF
     C                   ENDIF
 
      ** Save previous selector values
 
     C     *LIKE         DEFINE    #0LCDT        WZLCDT
     C                   EVAL      WZLCDT = #0LCDT
     C     *LIKE         DEFINE    #0CHTP        WZCHTP
     C                   EVAL      WZCHTP = #0CHTP
     C     *LIKE         DEFINE    #0POS1        WZYLDC
     C                   EVAL      WZYLDC = #0POS1
     C     *LIKE         DEFINE    #0POS2        WZYLDD
     C                   EVAL      WZYLDD = #0POS2
     C     *LIKE         DEFINE    #0POS3        WZYLDT
     C                   EVAL      WZYLDT = #0POS3
     C     *LIKE         DEFINE    #0POS4        WZINTP
     C                   EVAL      WZINTP = #0POS4
 
      ** Translate search mask for text field
 
     C     *LIKE         DEFINE    #0POS2        WQYLDD
 
     C                   CALL      'QDCXLATE'
     C                   PARM      20            WQA5N             5 0
     C                   PARM      #0POS2        WQYLDD
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 and #0RLRN = 0
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      *                                                               *
      * Calls    : SRClrScrn, SRMove, SRValidate, SRProtect           *
      *                                                               *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
      ** Load subfile page but write empty page if add mode
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        W0PMD <> 'ADD' and *IN27 and *IN82 = '0'
     C                   READP     @YLDCL1                                60
     C                   READ      @YLDCL1                                60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C     *IN82         DOWEQ     '0'
     C     WRCTR         ANDLE     WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             #0RLRN
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN87 = *OFF
 
      ** Protect fields during Enquiry Mode
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN78 = *ON
     C                   EVAL      *IN79 = *ON
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
 
     C                   IF        (W0PMD <> 'ADD')
     C                   SELECT
     C                   WHEN      #0LCDT <> 0  AND  FSLCDT <> #0LCDT
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0CHTP <> *BLANK  AND  FSCHTP <> #0CHTP
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0POS4 <> *BLANK  AND  FSINTP <> #0POS4
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0POS3 <> *BLANK  AND  FSYLDT <> #0POS3
     C                   EVAL      WSkipRec = 'Y'
 
     C                   WHEN      #0POS2 <> *BLANKS
 
     C                   CALL      'QCLSCAN'
     C                   PARM                    FSYLDD
     C                   PARM      20            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQYLDD
     C                   PARM      20            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** If CHANGE mode, load subfile fields
 
     C                   IF        W0PMD <> 'ADD'
     C                   EXSR      SRMove
 
      ** Validate subfile record and calculate derived fields
 
     C                   EXSR      SRValidate
 
     C                   ENDIF
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR                81
     C                   EVAL      *IN81 = *ON
 
      ** If SFLRCD invalid, note that errors present
 
     C                   IF        *IN83 and *IN40 = '0'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
      ** Set screen conditioning indicators
 
     C                   EXSR      SRProtect
 
     C                   WRITE     SD000741S0
 
     C                   ELSE
     C                   SUB       1             #0RLRN
     C                   ENDIF
 
      ** End of File
 
     C     W0PMD         IFNE      'ADD'
     C                   READ      @YLDCL1                                82
     C                   ENDIF
 
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Set screen conditioning indicators
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   EVAL      *IN37 = *OFF
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      *IN37 = *OFF
     C                   ENDIF
 
      ** PUTOVR unless conditioned fields change
 
     C                   EVAL      *IN86 = *ON
     C                   IF        *IN89 <> CAIN89 OR *IN81 <> CAIN81
     C                   EVAL      *IN86 = *OFF
     C                   ENDIF
 
     C                   EVAL      CAIN89 = *IN89
     C                   EVAL      CAIN81 = *IN81
 
      ** Display appropriate Header depending upon Mode whether it is
      ** Enquiry or Maintenance
 
     C                   IF        PMODE = 'E'
     C                   EVAL      *IN31 = *ON
     C                   ENDIF
 
      ** Selection mode (via Access Object)
 
     C                   IF        PMODE = '?'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Set cursor by *SET CURSOR data
 
     C                   TIME                    #0TIME
     C                   WRITE     SD000741C1
     C                   WRITE     SD000741F0
     C                   EXFMT     SD000741C0
 
      ** Clear messages from program message queue
 
     C                   CALL      'ZA0250'
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRReload, SRSubfileRec, SRUpdate, SRMode           *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** Change of position specified
 
     C                   IF        W0PMD <> 'ADD' and WPOSN <> SPOSN
     C                             OR WZYLDD <> #0POS2  OR  WZYLDT <> #0POS3
     C                             OR WZINTP <> #0POS4
     C                   EXSR      SRReload
     C                   ENDIF
 
      ** Quit if reload requested
 
     C     W0RSF         IFNE      'Y'
 
     C                   IF        *IN81 = *ON
     C                   EVAL      WKIPIN = 'N'
 
      ** Process subfile records
 
     C                   EXSR      SRSubfileRec
 
      ** Update DBF from subfile
 
     C                   IF        (*IN40 <> *ON) AND (WKIPIN = 'Y')
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   ENDIF
 
      ** Switch between *ADD/*CHANGE modes is allowed when no errors
      ** exists during update
 
     C                   IF        *IN09 and *IN40 = '0'
     C                   EXSR      SRMode
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSubfileRec - Process Modified Subfile Record                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAction, SRProtect                                *
      *                                                               *
      *****************************************************************
 
     C     SRSubfileRec  BEGSR
 
      ** Process modified subfile record
 
     C                   READC     SD000741S0                             62
 
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRAction
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRProtect
     C                   UPDATE    SD000741S0
     C                   READC     SD000741S0                             62
     C                   ENDDO
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAction - Process Subfile Record                             *
      *                                                               *
      * Called by: SRSubfileRec                                       *
      *                                                               *
      * Calls    : SRNullRecord, SRValidKey                           *
      *                                                               *
      *****************************************************************
 
     C     SRAction      BEGSR
 
      ** Set off error indicators
 
     C                   MOVEA     '000000'      *IN(32)
     C                   MOVEA     '00'          *IN(83)
 
      ** Check for null record if action is Insert
 
     C                   IF        W0PMD = 'ADD'
     C                   EXSR      SRNullRecord
     C                   ENDIF
 
      ** If not null record, continue
 
     C     W0NLR         IFNE      'Y'
     C                   EVAL      WKIPIN = 'Y'
 
     C                   EVAL      *IN84 = *ON
 
      ** Validate record
 
     C                   EXSR      SRValidKey
 
      ** Seton Global Error Indicator if error exists
 
     C                   IF        *IN83 = *ON
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRNullRecord - Check for Null Record                          *
      *                                                               *
      * Called by: SRAction, SRDetail                                 *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRNullRecord  BEGSR
 
     C                   EVAL      W0NLR = 'N'
 
     C     #0YLDC        IFEQ      *BLANKS
     C     #0YLDD        ANDEQ     *BLANKS
     C     #0YLDT        ANDEQ     *BLANKS
     C     #0INTP        ANDEQ     *BLANKS
     C                   EVAL      W0NLR = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidKey - Validate Subfile Record                          *
      *                                                               *
      * Called by: SRAction                                           *
      *                                                               *
      * Calls    : SRZasnms, SRValidate                               *
      *                                                               *
      *****************************************************************
 
     C     SRValidKey    BEGSR
 
      ** In Add mode, need to move screen value to hidden file field
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      ##YLDC = #0YLDC
     C                   ENDIF
 
      ** Yield Curve Name is blank
 
     C                   IF        #0YLDC = *BLANKS
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9158'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Yield Curve Description is blank
 
     C                   IF        #0YLDD = *BLANKS
     C                   EVAL      *IN34 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9159'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Yield Curve Type is blank
 
     C                   IF        #0YLDT = *BLANKS
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9160'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Interpolation Method is blank
 
     C                   IF        #0INTP = *BLANKS
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9161'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Action
 
     C                   IF        (#0SELC <> 'D') and (#0SELC <> *BLANKS)
     C                             AND (PMODE = 'M')
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9162'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** For selection mode, selection field must be '1'
 
     C                   IF        (PMODE = '?') AND (#0SELC <> '1') AND
     C                             (#0SELC <> *BLANKS)
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9173'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        (PMODE = '?') AND (#0SELC = '1')
     C                   EVAL      WNODAT = 'Y'
     C                   ADD       1             WSLCTR
     C                   IF        WSLCTR > 1
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9174'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Validate subfile record relations
 
     C                   EXSR      SRValidate
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate Subfile Record Relations                *
      *                                                               *
      * Called by: SRLoad, SRValidKey                                 *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
      ** Validate Yield Curve Name
 
     C                   IF        (#0YLDC = '*') OR (#0YLDC = '?')
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9177'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   EVAL      W_YLDC = #0YLDC
     C                   IF        W_YLDC1 = *Blanks
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9244'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   IF        W_YLDC2 = *Blanks AND
     C                             W_YLDC3 <> *Blanks OR
     C                             W_YLDC2 = *Blanks AND
     C                             W_YLDC4 <> *Blanks OR
     C                             W_YLDC2 = *Blanks AND
     C                             W_YLDC5 <> *Blanks
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9244'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   IF        W_YLDC3 = *Blanks AND
     C                             W_YLDC4 <> *Blanks OR
     C                             W_YLDC3 = *Blanks AND
     C                             W_YLDC5 <> *Blanks
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9244'
     C                   EXSR      SRZasnms
     C                   ELSE
     C                   IF        W_YLDC4 = *Blanks AND
     C                             W_YLDC5 <> *Blanks
     C                   EVAL      *IN33 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9244'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Curve Type
 
     C                   IF        (#0YLDT <> 'Z') AND (#0YLDT <> 'D')
     C                             AND (#0YLDT <> 'S')                                        228390
     C                   EVAL      *IN35 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9163'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Validate Interpolation Method
 
     C                   IF        (#0INTP <> 'Y') AND (#0INTP <> 'R') AND
     C                             (#0INTP <> 'S') AND (#0INTP <> 'E')
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9164'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Interpolation Method is 'Y' or 'R'
 
     C**********         IF        (#0INTP = 'Y') AND (#0YLDT <> 'Z') OR                      228390
     C**********                   (#0INTP = 'R') AND (#0YLDT <> 'Z')                         228390
     C                   IF        ((#0INTP = 'Y') AND (#0YLDT <> 'Z')                        228390
     C                             AND (#0YLDT <> 'S')) OR                                    228390
     C                             ((#0INTP = 'R') AND (#0YLDT <> 'Z')                        228390
     C                             AND (#0YLDT <> 'S'))                                       228390
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9165'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate - Update Records from Subfile                        *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDetail, SRProtect                                *
      *                                                               *
      *****************************************************************
 
     C     SRUpdate      BEGSR
 
      ** Initialise subfile reload flag
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      W0RSF = 'Y'
     C                   ELSE
     C                   EVAL      W0RSF = 'N'
     C                   ENDIF
 
      ** Process all modified subfile records
 
     C                   READC     SD000741S0                             62
 
     C                   DOW       *IN62 = *OFF
     C                   EXSR      SRDetail
 
      ** Rollback any DBF changes if error occur
 
     C                   IF        W#EROR <> *BLANKS
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                                                CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ELSE
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF
 
      ** Set screen conditioning indicators
 
     C                   EXSR      SRProtect
     C                   UPDATE    SD000741S0
     C                   READC     SD000741S0                             62
     C                   ENDDO
 
      ** Cancel reload if errors occur
 
     C                   IF        *IN40 = *ON
     C                   EVAL      W0RSF = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetail - Process action requested                           *
      *                                                               *
      * Called by: SRUpdate                                           *
      *                                                               *
      * Calls    : SRNullRecord, SRAddReq, SRDelReq, SRUpdReq         *
      *                                                               *
      *****************************************************************
 
     C     SRDetail      BEGSR
 
      ** Set off error indicators
 
     C                   MOVEA     '000000'      *IN(32)
     C                   EVAL      *IN83 = *OFF
 
      ** Process add request
 
     C                   IF        W0PMD = 'ADD'
 
     C                   EXSR      SRNullRecord
     C                   IF        W0NLR <> 'Y'
     C                   EXSR      SRAddReq
     C                   ENDIF
 
     C                   ELSE
 
      ** Process delete request
 
     C                   IF        #0SELC = 'D'
     C                   EXSR      SRDelReq
     C                   ELSE
 
      ** Process change request
 
     C                   EXSR      SRUpdReq
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN83 and *IN40 = *OFF
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAddReq - Process Add Request                                *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRWrite, SRTrailer                                 *
      *                                                               *
      *****************************************************************
 
     C     SRAddReq      BEGSR
 
      ** Create Yield Curve Details
 
     C                   EXSR      SRWrite
 
      ** Error detected
 
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '11111'       *IN(33)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87 = *OFF
     C                   ELSE
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN87 = *ON
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRDelete, SRMove, SRClrScrn                        *
      *                                                               *
      *****************************************************************
 
     C     SRDelReq      BEGSR
 
      ** Delete Yield Curve Details
 
     C                   EXSR      SRDelete
 
     C                   IF        W#EROR <> *BLANKS
 
      ** Delete unsuccessful
 
     C                   MOVEA     '111111'      *IN(32)
     C                   MOVEA     '11'          *IN(83)
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Blank out record and protect from entry
 
     C                   EXSR      SRTrailer
     C                   EXSR      SRClrScrn
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN87 = *ON
 
      ** Reload subfile
 
     C                   EVAL      W0RSF = 'Y'
     C                   EVAL      #0POS1 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdReq - Process Update Request                             *
      *                                                               *
      * Called by: SRDetail                                           *
      *                                                               *
      * Calls    : SRAmend, SRMove, SRTrailer                         *
      *                                                               *
      *****************************************************************
 
     C     SRUpdReq      BEGSR
 
      ** Amend Yield Curve Details
 
     C                   EXSR      SRAmend
 
     C                   IF        W#EROR <> *BLANKS
     C                   MOVEA     '111111'      *IN(32)
     C                   EVAL      *IN87 = *OFF
     C                   MOVEA     '11'          *IN(83)
 
      ** Reset subfile record if changed record
 
     C                   EXSR      SRMove
     C                   ELSE
 
      ** Enable entry
 
     C                   EVAL      *IN84 = *OFF
     C                   EVAL      *IN87 = *OFF
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      * Called by: SRAddReq, SRDelReq, SRUpdReq                       *
      *                                                               *
      * Calls    : *PSSR                                              *
      *                                                               *
      *****************************************************************
 
     C     SRTrailer     BEGSR
 
     C                   MOVEL     'SDYLDCPD'    WFNAM
     C     WFNAM         CHAIN     SDFCTLL0                           60
 
     C                   IF        *IN60
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = WFNAM
     C                   EVAL      DBPGM = 'SD000741'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   SELECT
     C     W0PMD         WHENEQ    'ADD'
     C                   ADD       1             AHNORC
     C                   ADD       1             AHNOIN
     C     #0SELC        WHENEQ    'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
     C     YCRDC         WHENEQ    'Y'
     C                   ADD       1             AHNOAM
     C                   ENDSL
 
     C                   ENDIF
 
     C                   UPDATE    @AHREAU
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   COMMIT
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   COMMIT                                                               CSC022
     C                   END                                                                  CSC022
     C                   ENDIF                                                                CSC022
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMode - Switch Between *ADD and *CHANGE Modes                *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRReload                                           *
      *                                                               *
      *****************************************************************
 
     C     SRMode        BEGSR
 
      ** Switch between *ADD/*CHANGE modes
 
     C                   IF        W0PMD <> 'ADD'
     C                   EVAL      W0PMD = 'ADD'
     C                   ELSE
     C                   EVAL      W0PMD = 'CHG'
     C                   ENDIF
 
     C                   EVAL      SPOSN = *BLANKS
 
     C                   EXSR      SRReload
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRReload - Request Subfile Reload                             *
      *                                                               *
      * Called by: Main routine, SRProcess, SRMode                    *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRReload      BEGSR
 
      ** Request subfile reload
 
     C                   EVAL      W0RSF = 'Y'
 
     C                   IF        *IN05
     C                   EVAL      SPOSN = *BLANKS
     C                   EVAL      #0SELC = *BLANKS
     C                   EVAL      #0POS2 = *Blanks
     C                   EVAL      #0POS3 = *Blanks
     C                   EVAL      #0POS4 = *Blanks
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProtect - Set Display Attributes for Subfile Record         *
      *                                                               *
      * Called by: SRLoad, SRSubfileRec, SRUpdate                     *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRProtect     BEGSR
 
     C                   IF        W0PMD = 'ADD'
     C                   EVAL      *IN89 = *ON
     C                   ELSE
     C                   EVAL      *IN89 = *OFF
     C                   ENDIF
 
      ** Protect keys if change mode or updated record
 
     C                   MOVEL     *IN87         *IN79
     C                   IF        *IN89
     C                   EVAL      *IN79 = *ON
     C                   ENDIF
 
     C                   MOVEL     *IN87         *IN78
     C                   IF        W0PMD = 'CHG'
     C                   EVAL      *IN78 = *ON
     C                   ENDIF
 
      ** Protect fields during Selection Mode
 
     C                   IF        PMODE = '?'
     C                   EVAL      *IN87 = *ON
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      * Called by: SRLoad, SRDelReq                                   *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      ##DBRC = *BLANKS
     C                   EVAL      ##YLDC = *BLANKS
     C                   EVAL      #0RECI = *BLANKS
     C                   EVAL      #0CHTP = *BLANKS
     C                   EVAL      #0LCDT = *ZEROS
     C                   EVAL      #0SELC = *BLANKS
     C                   EVAL      #0YLDC = *BLANKS
     C                   EVAL      #0YLDD = *BLANKS
     C                   EVAL      #0YLDT = *BLANKS
     C                   EVAL      #0INTP = *BLANKS
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Transfer Records from SDYLDCL1 to Subfile            *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRUpdReq                         *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
      ** Move SDYLDCL0 fields to subfile
 
     C                   EVAL      ##YLDC = FSYLDC
     C                   EVAL      #0RECI = FSRECI
     C                   EVAL      #0YLDC = FSYLDC
     C                   EVAL      #0YLDD = FSYLDD
     C                   EVAL      #0YLDT = FSYLDT
     C                   EVAL      #0INTP = FSINTP
 
      ** Hold current record image for change detection
 
     C                   EVAL      ##DBRC = @1DBRC
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Yield Curve Details                          *
      *                                                               *
      * Called by: SRAddReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Create Yield Curve Details
 
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSYLDC = ##YLDC
     C                   EVAL      FSCHTP = 'I'
     C                   Z-ADD     BJRDNB        FSLCDT
     C                   EVAL      FSYLDD = #0YLDD
     C                   EVAL      FSYLDT = #0YLDT
     C                   EVAL      FSINTP = #0INTP
 
     C                   CALLB     'ZAGENTMSTM'                                             BUG14109
     C                   PARM                    TimeStamp                                  BUG14109
     C                   EVAL      FSTMST = TimeStamp                                       BUG14109
 
      ** Check for duplicate primary key
 
     C                   EVAL      #0POS1 = ##YLDC
 
     C     #0POS1        SETLL     @YLDCL0                                60
 
     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9166'
     C                   EXSR      SRZasnms
     C                   ELSE
 
     C                   WRITE     @YLDCL0                              61
 
      ** Write error detected
 
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Yield Curve Details                         *
      *                                                               *
      * Called by: SRDelreq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
      ** Delete Yield Curve Details
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Set Key Fields
 
     C                   EVAL      #0POS1 = #0YLDC
 
      ** Check if the Yield Curve is a live transaction (Deal or Loan) is
      ** linked to it
 
     C     #0POS1        CHAIN     @TRANL0                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TRANL1                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TRANL2                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TRANL3                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TRANL4                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TRANL5                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9167'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Check if Yield Curve has a deal/loan sub-type linked to it
 
     C     #0POS1        CHAIN     @TPSTL0                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9168'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TPSTL1                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9168'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TPSTL2                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9168'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN60 = *ON
     C     #0POS1        CHAIN     @TPSTL3                            60
     C                   IF        *IN60 = *OFF
     C                   EVAL      *IN32 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR9168'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
                                                                                              228995
      ** Check if Yield Curve still has Yield Rates linked to it                              228995
                                                                                              228995
     C     #0POS1        CHAIN     SDYLDRD0                           60                      228995
     C                   IF        *IN60 = *OFF                                               228995
     C                   EVAL      *IN32 = *ON                                                228995
     C                   EVAL      *IN83 = *ON                                                228995
     C                   EVAL      W#EROR = 'Y'                                               228995
     C**********         EVAL      PZMsgID = 'USR9267'                                228995 BUG9330
     C                   EVAL      PZMsgID = 'USR9500'                                       BUG9330
     C                   EXSR      SRZasnms                                                   228995
     C                   ENDIF                                                                228995
 
     C     #0POS1        CHAIN     @YLDCL0                            6061
 
      ** Record already deleted
 
     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Record locked
 
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7603'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Check for changed record
 
     C                   IF        ##DBRC <> @1DBRC
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
 
      ** Release record lock
 
     C     #0POS1        SETLL     @YLDCL0                            6061
     C                   ELSE
 
     C                   DELETE    @YLDCL0                              61
 
      ** Delete error detected
 
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Update Yield Curve Details                         *
      *                                                               *
      * Called by: SRUpdReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
      ** Change Yield Curve Details
 
     C                   EVAL      W#EROR = *BLANKS
 
      ** Set record data changed flag
 
     C                   EVAL      YCRDC = 'N'
 
      ** Check if a live Loan transaction is linked to a yield curve as its
      ** Forward Yield Curve, the Interpolation Method cannot be amended
 
     C                   IF        W0PMD = 'CHG'
     C                   EVAL      #0POS1 = ##YLDC
     C     #0POS1        CHAIN     @YLDCL1                            60
     C                   IF        #0INTP <> FSINTP
     C     #0POS1        CHAIN     @TRANL1                            61
     C                   IF        *IN61 = *OFF
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      *IN36 = *ON
     C                   EVAL      *IN83 = *ON
     C                   EVAL      PZMsgID = 'USR9169'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Move key fields to SDYLDCL0
 
     C                   EVAL      #0POS1 = ##YLDC
 
     C     #0POS1        CHAIN     @YLDCL0                            6061
 
      ** Record not found
 
     C                   IF        *IN60
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Record locked
 
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ELSE
 
      ** Check for changed record
 
     C                   IF        ##DBRC <> @1DBRC
     C                   EVAL      W#EROR = 'Y'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
     C                   UNLOCK    SDYLDCL0                             61
     C                   ELSE
 
      ** Store record data for null update check
 
     C                   EVAL      YCRDCS = @1DBRC
 
      ** Move non-key fields to SDYLDCL0
 
     C                   EVAL      FSRECI = 'D'
     C                   EVAL      FSYLDC = ##YLDC
     C                   EVAL      FSYLDD = #0YLDD
     C                   EVAL      FSYLDT = #0YLDT
     C                   EVAL      FSINTP = #0INTP
     C                   EVAL      FSCHTP = 'A'
     C                   Z-ADD     BJRDNB        FSLCDT
 
     C                   IF        @1DBRC <> YCRDCS
     C                   EVAL      YCRDC = 'Y'
     C                   ENDIF
 
      ** If changed update record otherwise release record
 
     C                   IF        YCRDC = 'Y'
     C                   UPDATE    @YLDCL0                              61
     C                   ELSE
     C                   UNLOCK    SDYLDCL0                             61
     C                   ENDIF
 
      ** Change error detected
 
     C                   IF        *IN61
     C                   EVAL      W#EROR = 'Y'
     C                   ELSE
 
      ** Update saved record image
 
     C                   EVAL      ##DBRC = @1DBRC
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : ZA0340                                             *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
     C                   IF        PZMsgFile = *BLANKS
     C                   EVAL      PZMsgFile = ZADFMF
     C                   ENDIF
 
     C                   CALL      'ZA0340'
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgID
 
     C                   EVAL      PZMsgFile = *BLANKS
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
      ** Rollback any uncommitted DBF changes
 
     C     CSC022        IFEQ      'N'                                                        CSC022
     C                   ROLBK                                          60
     C                   ELSE                                                                 CSC022
     C     COMITSKIP     IFNE      'Y'                                                        CSC022
     C                   ROLBK                                          60                    CSC022
     C                   ELSE                                                                 CSC022
     C                   SETON                                        U7U8                    CSC022
     C                   ENDIF                                                                CSC022
     C                   ENDIF                                                                CSC022
 
      ** If selection mode and F3 has been pressed
 
     C                   IF        PMODE = '?'
     C                   EVAL      PRTCD = '*NOSEL '
     C                   EVAL      PYLDC = *Blanks
     C                   ENDIF
 
      ** Terminate program
 
     C                   EVAL      *INLR = *ON
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
