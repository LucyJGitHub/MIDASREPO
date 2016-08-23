     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DL Fwd reval by NPV method - on request')        *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL0420 - Forward Commitments Revaluation Report - On Request *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *  Prev Amend No. BUG13693           Date 03Apr07               *
      *                 242593             Date 21Nov06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 225831             Date 19Mar04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS005             Date 16Dec02               *
      *                 216940             Date 11Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001  *CREATE    Date 23Nov01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  BUG13693 - Component DLC0420 10001 failed, db error 3        *
      *  242593 - Database error occurs in SDBOOKPD when Internal     *
      *           Contract deals with blank book codes are processed. *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type                              *
      *  225831 - If yield curve rate combination was not found,      *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  216940 - Amounts were not properly formatted                 *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of File in DLNPVLL1                         *
      *    02         Multibranching ON                               *
      *    U7/U8/LR   Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRPROCES      -  Process Records from File DLNPVLL1          *
      *  SRDETAIL      -  Process and Print Detail Record Line        *
      *  SRMTHBRK      -  Process Monthly Report Lines                *
      *  SRYRBRK       -  Process Annual Report Lines                 *
      *  SRBOKBRK      -  Process Book Code Details / Annual Routine  *
      *  SRCCYBRK      -  Process Total Report Lines                  *
      *  SRBRCBRK      -  Process Branch Code Details / Total Routine *
      *  SROPNCLO      -  Open and Close Printer Files                *
      *  SRCHKLIN      -  Check Available Space of Report             *
      *  SRWP1END      -  Write End of Report                         *
      *  SRRCFP1       -  Register P1 Printer File via RCF            *
      *  SRRCFAU       -  Register AU Printer File via RCF            *
      *  SRFMTAMT      -  Format Printer File Fields Amount           *
      *  SRAUDIT       -  Output Audit Report and End Program         *
      *  *INZSR        -  Program Initialisation Routine              *
      *  *PSSR         -  Error handling subroutine                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FDLNPVLL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL Re-valued Forward Commitments File by CCY/Book/Value
 
     FDL0420P1  O    E             PRINTER INFDS(SPOOL1) USROPN INFSR(*PSSR)
      ** Midas DL Forward Commitments Revaluation Method 'N' or ' '
 
     FDL0420P3  O    E             PRINTER INFDS(SPOOL3) USROPN INFSR(*PSSR)
      ** Midas DL Forward Commitments Revaluation Method 'F'
 
     FDL0420P4  O    E             PRINTER INFDS(SPOOL4) USROPN INFSR(*PSSR)
      ** Midas DL Forward Commitments Revaluation Method 'B'
 
     FDL0420P5  O    E             PRINTER INFDS(SPOOL5) USROPN INFSR(*PSSR)
      ** Midas DL Forward Commitments Revaluation Method 'D'
 
     FDL0420AU  O    E             PRINTER INFDS(SPOOLU) USROPN INFSR(*PSSR)
      ** Midas DL Forward Commitments Revaluation - Audit
 
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
 
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Externally described DS for book details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** Externally described DS for branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Externally described DS for Rundate details
     D RUNDAT        E DS                  EXTNAME(RUNDAT) DTAARA
 
      ** DS for access objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for DL0420P1
     D SPOOL1          DS
     D   SFILE1               83     92
     D   SFNUM1              123    124B 0
     D   OFLLN1              188    189B 0
     D   PRTLN1              367    368B 0
 
      ** File Information Data Structure for DL0420P3
     D SPOOL3          DS
     D   SFILE3               83     92
     D   SFNUM3              123    124B 0
     D   OFLLN3              188    189B 0
     D   PRTLN3              367    368B 0
 
      ** File Information Data Structure for DL0420P4
     D SPOOL4          DS
     D   SFILE4               83     92
     D   SFNUM4              123    124B 0
     D   OFLLN4              188    189B 0
     D   PRTLN4              367    368B 0
 
      ** File Information Data Structure for DL0420P5
     D SPOOL5          DS
     D   SFILE5               83     92
     D   SFNUM5              123    124B 0
     D   OFLLN5              188    189B 0
     D   PRTLN5              367    368B 0
 
      ** File Information Data Structure for DL0420AU
     D SPOOLU          DS
     D   SFILEU               83     92
     D   SFNUMU              123    124B 0
 
      ** Value Date Data Structure
     D DSDATE          DS
     D   DSDAY                 1      2
     D   DSMONTH               3      5
     D   DSYEAR                6      7
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry Parameter
     D PSEQN           S              5A
     D PBRCA           S              3A
     D PNPVM           S              1A
 
      ** Parameters for ZDATE2
     D PDAYNO          S              5P 0
     D PDATE           S              6P 0
     D PADATE          S              7A
 
      ** Parameters for ZSFILE
     D PENTY           S              3A
     D SFILE           S             10A
     D SFNUM           S              6  0
     D PERR            S              1A
 
      ** Parameters for ZSEDITF
     D PINAMT          S             15P 0
     D PINDEC          S              1P 0
     D PINCODE         S              1A
     D PINCHAR         S              1A
     D POUTAMT         S             21A
 
      ** Parameters for access object programs
     D PRTCD           S              7A
     D POPTN           S              7A
 
      ** Other fields used
     D WMEAMT          S             13P 0
     D WMDBCE          S             15P 0
     D WMREVA          S             15P 0
     D WMPRLA          S             13P 0
     D WYEAMT          S             13P 0
     D WYDBCE          S             15P 0
     D WYREVA          S             15P 0
     D WYPRLA          S             13P 0
     D WTEAMT          S             13P 0
     D WTDBCE          S             15P 0
     D WTREVA          S             15P 0
     D WTPROF          S             13P 0
     D WTLOSS          S             13P 0
     D WTPRLA          S             13P 0
     D WRQDLN          S              3  0
     D WDIFLN          S              3  0
     D WBRCA           S              3A
     D WCYCD           S              3A
     D WBKCD           S              2A
     D WMONTH          S              3A
     D WYEAR           S              2A
     D WOPEN           S              1A
     D WFIRST          S              1A
     D WRUN            S              1A
     D WBsNBDP         S              1P 0                                                    216940
 
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
 
      ** Perform Detail Processing
 
     C                   EXSR      SRPROCES
 
      ** Output Audit Report and End Program
 
     C                   EXSR      SRAUDIT
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROCES - Process Records from File DLNPVLL1                *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls: SRAUDIT  SRBRCBRK  SRCCYBRK  SRBOKBRK  SRYRBRK        *
      *         SRMTHBRK  SRDETAIL                                    *
      *                                                               *
      *****************************************************************
 
     C     SRPROCES      BEGSR
 
      ** Read first record from File
 
     C     *LOVAL        SETLL     DLNPVLL1
     C                   READ      DLNPVLL1                               01
 
      ** If end of record, perform audit reporting
 
     C                   IF        *IN01 = *ON
     C                   EXSR      SRAUDIT
     C                   ELSE
 
      ** Call Access Program for Currency Details
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FSCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = FSCYCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RCYCD = FSCYCD
     C                   ENDIF
 
      ** Call Access Program for Book Details
 
     C     FSDTYP        IFEQ      'PS'                                                       242593
     C     FSBKCD        ANDEQ     *BLANKS                                                    242593
      *                                                                                       242593
     C                   EVAL      RBKCD = FSBKCD                                             242593
     C                   EVAL      RDBKD = *BLANKS                                            242593
     C                   EVAL      RDBKD = 'Blank Book Code'                                  242593
     C                   EVAL      BDBKD = *BLANKS                                            242593
     C                   EVAL      BDBKD = 'Blank Book Code'                                  242593
     C                   ELSE                                                                 242593
      *                                                                                       242593
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FSBKCD
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RBKCD = FSBKCD
     C                   EVAL      RDBKD = BDBKD
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                242593
 
      ** Do Until End of File
 
     C                   DOW       *IN01 = *OFF
 
      ** Check if Branch read is the requested branch
 
     C                   IF        PBRCA = 'ALL' OR
     C                             PBRCA = *BLANKS OR
     C                             PBRCA = FSBRCA
 
      ** Process only selected NPV records
 
     C                   IF        PNPVM = FSNPVM OR
     C                             PNPVM = 'N' AND
     C                             FSNPVM = ' ' OR
     C                             PNPVM = ' ' AND
     C                             FSNPVM = 'N' OR
     C                             PNPVM = '*'
 
      ** Count records read
 
     C                   EVAL      RCOUNT = RCOUNT + 1
 
      ** Convert value date to DDMMMYY format
 
     C                   EVAL      PDAYNO = FSVDAT
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDAYNO
     C                   PARM                    BJDFIN
     C                   PARM      *ZERO         PDATE
     C                   PARM      *BLANKS       PADATE
     C                   EVAL      DSDATE = PADATE
 
      ** Check if Branch has changed
 
     C                   IF        FSBRCA <> WBRCA
     C                   EXSR      SRBRCBRK
     C                   ENDIF
 
      ** Check if Currency has changed
 
     C                   IF        FSCYCD <> WCYCD
     C                   EXSR      SRCCYBRK
     C                   ENDIF
 
      ** Check if Book Code has changed
 
     C                   IF        FSBKCD <> WBKCD
     C                   EXSR      SRBOKBRK
     C                   EVAL      WBKCD = FSBKCD
     C                   ENDIF
 
      ** Check if Year has changed
 
     C                   IF        DSYEAR <> WYEAR
     C                   EXSR      SRYRBRK
     C                   ENDIF
 
      ** Check if Month has changed
 
     C                   IF        DSMONTH <> WMONTH
     C                   EXSR      SRMTHBRK
     C                   ENDIF
 
      ** Process Detail Record
 
     C                   EXSR      SRDETAIL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Read next record
 
     C                   READ      DLNPVLL1                               01
 
     C                   ENDDO
 
      ** EOF execute SRBRCBRK to print out totals if there were
      ** records read
 
     C                   IF        RCOUNT <> 0
     C                   EXSR      SRBRCBRK
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDETAIL - Process and Print Detail Record Line              *
      *                                                               *
      *  Called by: SRPROCES                                          *
      *                                                               *
      *  Calls    : SRFMTAMT  SRCHKLIN                                *
      *                                                               *
      *****************************************************************
 
     C     SRDETAIL      BEGSR
 
      ** Move Input Fields to Output Fields
 
     C                   EVAL      RVDAT = PADATE
     C                   EVAL      RCNUM = FSCNUM
 
     C                   IF        FSDLNO <> 0
     C                   EVAL      *IN50 = *ON
     C                   EVAL      *IN60 = *OFF
     C                   EVAL      RDLNO = FSDLNO
     C                   ELSE
     C                   EVAL      *IN50 = *OFF
     C                   EVAL      *IN60 = *ON
     C                   EVAL      RPREF = FSPREF
     C                   ENDIF
 
     C                   EVAL      *IN30 = *OFF                                               225831
                                                                                              225831
     C                   IF        FSDSCF = 0 AND                                             225831
     C                             FSPRLA = 0                                                 225831
     C                   EVAL      *IN30 = *ON                                                225831
     C                   ENDIF                                                                225831
                                                                                              225831
     C                   EVAL      RDTYP = FSDTYP
     C                   EVAL      RDLST = FSDLST
     C                   EVAL      RCLAS = FSCLAS                                             CDL038
 
     C                   MOVE      FSYLDC        RYLDC
     C                   MOVE      FSMRAT        RMRAT
     C                   MOVE      FSDSCF        RDSCF
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      FSDAMT        PINAMT
     C                   EVAL      PINDEC = A6NBDP
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       REAMT
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      FSEAMT        PINAMT
     C**********         EVAL      PINDEC = A6NBDP                                            216940
     C                   EVAL      PINDEC = WBsNBDP                                           216940
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RDBCE
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      FSREVA        PINAMT
     C**********         EVAL      PINDEC = A6NBDP                                            216940
     C                   EVAL      PINDEC = WBsNBDP                                           216940
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RREVA
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      FSPRLA        PINAMT
     C**********         EVAL      PINDEC = A6NBDP                                            216940
     C                   EVAL      PINDEC = WBsNBDP                                           216940
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RPRLA
 
     C                   Z-ADD     2             WRQDLN
     C                   EXSR      SRCHKLIN
 
      ** Select which Record Format to Write by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     DETAILP1D1
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     DETAILP3D1
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     DETAILP4D1
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     DETAILP5D1
 
     C                   ENDSL
 
      ** Update Monthly Total
 
     C                   ADD       FSDAMT        WMEAMT
     C                   ADD       FSEAMT        WMDBCE
     C                   ADD       FSREVA        WMREVA
     C                   ADD       FSPRLA        WMPRLA
 
      ** Check if Profit or Loss
 
     C                   IF        FSPRLA < 0
     C                   ADD       FSPRLA        WTLOSS
     C                   ELSE
     C                   ADD       FSPRLA        WTPROF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRMTHBRK - Process Monthly Report Lines                      *
      *                                                               *
      *  Called by: SRPROCES  SRYRBRK                                 *
      *                                                               *
      *  Calls    : SRCHKLIN                                          *
      *                                                               *
      *****************************************************************
 
     C     SRMTHBRK      BEGSR
 
      ** Move Input Fields to Output Fields
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WMEAMT        PINAMT
     C                   EVAL      PINDEC = A6NBDP
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RMEAMT
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WMDBCE        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RMDBCE
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WMREVA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RMREVA
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WMPRLA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RMPRLA
 
     C                   Z-ADD     4             WRQDLN
     C                   EXSR      SRCHKLIN
 
      ** Select which Record Format to Write by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     DETAILP1D2
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     DETAILP3D2
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     DETAILP4D2
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     DETAILP5D2
 
     C                   ENDSL
 
      ** Update Annual Total
 
     C                   ADD       WMEAMT        WYEAMT
     C                   ADD       WMDBCE        WYDBCE
     C                   ADD       WMREVA        WYREVA
     C                   ADD       WMPRLA        WYPRLA
 
      ** Initialize Monthly Total
 
     C                   Z-ADD     *ZEROS        WMEAMT
     C                   Z-ADD     *ZEROS        WMDBCE
     C                   Z-ADD     *ZEROS        WMREVA
     C                   Z-ADD     *ZEROS        WMPRLA
 
      ** Save New Month
 
     C                   EVAL      WMONTH = DSMONTH
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRYRBRK - Process Annual Report Lines                        *
      *                                                               *
      *  Called by: SRPROCES  SRBOKBRK                                *
      *                                                               *
      *  Calls    : SRMTHBRK  SRCHKLIN                                *
      *                                                               *
      *****************************************************************
 
     C     SRYRBRK       BEGSR
 
      ** Execute Monthly Routine
 
     C                   EXSR      SRMTHBRK
 
      ** Move Input Fields to Output Fields
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WYEAMT        PINAMT
     C                   EVAL      PINDEC = A6NBDP
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RYEAMT
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WYDBCE        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RYDBCE
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WYREVA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RYREVA
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WYPRLA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RYPRLA
 
     C                   Z-ADD     2             WRQDLN
     C                   EXSR      SRCHKLIN
 
      ** Select which Record Format to Write by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     DETAILP1D3
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     DETAILP3D3
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     DETAILP4D3
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     DETAILP5D3
 
     C                   ENDSL
 
      ** Update Total
 
     C                   ADD       WYEAMT        WTEAMT
     C                   ADD       WYDBCE        WTDBCE
     C                   ADD       WYREVA        WTREVA
 
      ** Initialize Yearly Total
 
     C                   Z-ADD     *ZEROS        WYEAMT
     C                   Z-ADD     *ZEROS        WYDBCE
     C                   Z-ADD     *ZEROS        WYREVA
     C                   Z-ADD     *ZEROS        WYPRLA
 
      ** Save New Year
 
     C                   EVAL      WYEAR = DSYEAR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBOKBRK - Process Book Code Details / Annual Routine        *
      *                                                               *
      *  Called by: SRPROCES  SRCCYBRK                                *
      *                                                               *
      *  Calls    : SRYRBRK                                           *
      *                                                               *
      *****************************************************************
 
     C     SRBOKBRK      BEGSR
 
      ** Execute Annual Routine
 
     C                   EXSR      SRYRBRK
 
      ** Call Access Program for Book Details
 
     C                   IF        *IN01 = *OFF
      *                                                                                     BUG13693
      ** Call access object for book code if book code not equal to blanks                  BUG13693
      *                                                                                     BUG13693
     C                             And FSBKCD <> *Blanks                                    BUG13693
 
     C     FSDTYP        IFEQ      'PS'                                                       242593
     C     FSBKCD        ANDEQ     *BLANKS                                                    242593
      *                                                                                       242593
     C                   EVAL      RBKCD = FSBKCD                                             242593
     C                   EVAL      RDBKD = *BLANKS                                            242593
     C                   EVAL      RDBKD = 'Blank Book Code'                                  242593
     C                   EVAL      BDBKD = *BLANKS                                            242593
     C                   EVAL      BDBKD = 'Blank Book Code'                                  242593
     C                   ELSE                                                                 242593
      *                                                                                       242593
     C                   CALL      'AOBOOKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    FSBKCD
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = FSBKCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                                242593
 
     C                   IF        FSCYCD = WCYCD AND
     C                             FSBRCA = WBRCA
 
     C     FSDTYP        IFEQ      'PS'                                                       242593
     C     FSBKCD        ANDEQ     *BLANKS                                                    242593
      *                                                                                       242593
     C                   EVAL      RBKCD = FSBKCD                                             242593
     C                   EVAL      RDBKD = *BLANKS                                            242593
     C                   EVAL      RDBKD = 'Blank Book Code'                                  242593
     C                   EVAL      BDBKD = *BLANKS                                            242593
     C                   EVAL      BDBKD = 'Blank Book Code'                                  242593
     C                   ELSE                                                                 242593
      *                                                                                       242593
     C                   EVAL      RBKCD = FSBKCD
     C                   EVAL      RDBKD = BDBKD
     C                   ENDIF                                                                242593
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     HEADP1H1
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     HEADP3H1
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     HEADP4H1
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     HEADP5H1
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Save new book code
 
     C                   EVAL      WBKCD = FSBKCD
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCYBRK - Process Total Report Lines                        *
      *                                                               *
      *  Called by: SRPROCES  SRBRCBRK                                *
      *                                                               *
      *  Calls    : SRBOKBRK  SRCHKLIN                                *
      *                                                               *
      *****************************************************************
 
     C     SRCCYBRK      BEGSR
 
      ** Execute Annual Routine
 
     C                   EXSR      SRBOKBRK
 
      ** Update Net Total
 
     C                   EVAL      WTPRLA = WTPROF + WTLOSS
 
      ** Move Input Fields to Output Fields
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTEAMT        PINAMT
     C                   EVAL      PINDEC = A6NBDP
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTEAMT
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTDBCE        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTDBCE
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTREVA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTREVA
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTPROF        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTPROF
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTLOSS        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTLOSS
 
     C                   MOVE      *BLANKS       PINAMT
     C                   MOVE      WTPRLA        PINAMT
     C*******************EVAL      PINDEC = A6NBDP                                            CDL038
     C                   EVAL      PINDEC = WBsNBDP                                           CDL038
     C                   EVAL      PINCODE = 'J'
     C                   EXSR      SRFMTAMT
     C                   MOVE      POUTAMT       RTPRLA
 
     C                   Z-ADD     6             WRQDLN
     C                   EXSR      SRCHKLIN
 
      ** Select which Record Format to Write by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     DETAILP1D4
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     DETAILP3D4
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     DETAILP4D4
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     DETAILP5D4
 
     C                   ENDSL
 
      ** Initialize Total
 
     C                   Z-ADD     *ZEROS        WTEAMT
     C                   Z-ADD     *ZEROS        WTDBCE
     C                   Z-ADD     *ZEROS        WTREVA
     C                   Z-ADD     *ZEROS        WTPROF
     C                   Z-ADD     *ZEROS        WTLOSS
     C                   Z-ADD     *ZEROS        WTPRLA
 
      ** Call Access Program for Currency Details
 
     C                   IF        *IN01 = *OFF
 
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    FSCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = FSCYCD
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Only write header when there's a change in currency
 
     C                   IF        FSBRCA = WBRCA
 
     C                   EVAL      RCYCD = FSCYCD
     C                   EVAL      RBKCD = FSBKCD
     C                   EVAL      RDBKD = BDBKD
      *                                                                                       242593
     C     FSDTYP        IFEQ      'PS'                                                       242593
     C     FSBKCD        ANDEQ     *BLANKS                                                    242593
     C                   EVAL      RBKCD = FSBKCD                                             242593
     C                   EVAL      RDBKD = *BLANKS                                            242593
     C                   EVAL      RDBKD = 'Blank Book Code'                                  242593
     C                   EVAL      BDBKD = *BLANKS                                            242593
     C                   EVAL      BDBKD = 'Blank Book Code'                                  242593
     C                   ENDIF                                                                242593
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     HEADP1H1
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     HEADP3H1
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     HEADP4H1
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     HEADP5H1
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Save new currency
 
     C                   EVAL      WCYCD = FSCYCD
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRCBRK - Process Branch Code Details / Total Routine       *
      *                                                               *
      *  Called by: SRPROCES                                          *
      *                                                               *
      *  Calls    : SRCCYBRK  SRWP1END  SROPNCLO                      *
      *                                                               *
      *****************************************************************
 
     C     SRBRCBRK      BEGSR
 
      ** Execute CCY routine unless this is 1st record read and write
      ** trailer narrative for branch
 
     C                   IF        WFIRST <> 'Y'
 
     C                   EXSR      SRCCYBRK
 
      ** Write End of Report Narrative
 
     C                   EXSR      SRWP1END
 
     C                   ENDIF
 
      ** Call access program to get Branch Details only if not EOF
 
     C                   IF        *IN01 = *OFF
 
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY    '    POPTN
     C                   PARM                    FSBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBASE = 5
     C                   EVAL      DBKEY = FSBRCA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   EVAL      RBRCA = FSBRCA
     C                   EVAL      RBRNM = A8BRNM
     C                   EVAL      RCYCD = FSCYCD
     C                   EVAL      RBKCD = FSBKCD
     C                   EVAL      RDBKD = BDBKD
      *                                                                                       242593
     C     FSDTYP        IFEQ      'PS'                                                       242593
     C     FSBKCD        ANDEQ     *BLANKS                                                    242593
     C                   EVAL      RBKCD = FSBKCD                                             242593
     C                   EVAL      RDBKD = *BLANKS                                            242593
     C                   EVAL      RDBKD = 'Blank Book Code'                                  242593
     C                   EVAL      BDBKD = *BLANKS                                            242593
     C                   EVAL      BDBKD = 'Blank Book Code'                                  242593
     C                   ENDIF                                                                242593
     C                   EXSR      SROPNCLO
     C                   ENDIF
 
     C                   IF        WFIRST = 'Y'
     C                   EVAL      WCYCD = FSCYCD
     C                   EVAL      WBKCD = FSBKCD
     C                   EVAL      WYEAR = DSYEAR
     C                   EVAL      WMONTH = DSMONTH
     C                   ENDIF
 
     C                   EVAL      WFIRST = 'N'
 
      ** Save New Branch
 
     C                   EVAL      WBRCA = FSBRCA
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROPNCLO - Open and Close Printer Files                      *
      *                                                               *
      *  Called by: SRBRCBRK                                          *
      *                                                               *
      *  Calls    : SRRCFP1                                           *
      *                                                               *
      *****************************************************************
 
     C     SROPNCLO      BEGSR
 
      ** Open a new Spool File for the new Branch
 
     C                   IF        WOPEN = 'Y'
 
      ** Select which File to Close by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   CLOSE     DL0420P1
 
     C                   WHEN      PNPVM = 'F'
     C                   CLOSE     DL0420P3
 
     C                   WHEN      PNPVM = 'B'
     C                   CLOSE     DL0420P4
 
     C                   WHEN      PNPVM = 'D'
     C                   CLOSE     DL0420P5
 
     C                   ENDSL
 
     C                   ENDIF
 
      ** Select which File to Open by NPV
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   OPEN      DL0420P1
     C                   EVAL      SFNUM = SFNUM1
     C                   EVAL      SFILE = SFILE1
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP1H1
 
     C                   WHEN      PNPVM = 'F'
     C                   OPEN      DL0420P3
     C                   EVAL      SFNUM = SFNUM3
     C                   EVAL      SFILE = SFILE3
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP3H1
 
     C                   WHEN      PNPVM = 'B'
     C                   OPEN      DL0420P4
     C                   EVAL      SFNUM = SFNUM4
     C                   EVAL      SFILE = SFILE4
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP4H1
 
     C                   WHEN      PNPVM = 'D'
     C                   OPEN      DL0420P5
     C                   EVAL      SFNUM = SFNUM5
     C                   EVAL      SFILE = SFILE5
     C                   EXSR      SRRCFP1
     C                   WRITE     HEADP5H1
 
     C                   ENDSL
 
     C                   EVAL      WOPEN = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKLIN - Check Available Space of Report                   *
      *                                                               *
      *  Called by: SRDETAIL  SRMTHBRK  SRYRBRK  SRCCYBRK  SRWP1END   *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRCHKLIN      BEGSR
 
      ** Check if there are sufficient lines to print
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   EVAL      WDIFLN = OFLLN1 - PRTLN1
 
     C                   WHEN      PNPVM = 'F'
     C                   EVAL      WDIFLN = OFLLN3 - PRTLN3
 
     C                   WHEN      PNPVM = 'B'
     C                   EVAL      WDIFLN = OFLLN4 - PRTLN4
 
     C                   WHEN      PNPVM = 'D'
     C                   EVAL      WDIFLN = OFLLN5 - PRTLN5
 
     C                   ENDSL
 
     C                   IF        WDIFLN <= WRQDLN
 
      ** If lines are not sufficient print out header for a new a page.
      ** Select which NPV was requested to determine which header format
      ** to print.
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     HEADP1H1
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     HEADP3H1
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     HEADP4H1
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     HEADP5H1
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWP1END - Write End of Report                               *
      *                                                               *
      *  Called by: SRBRCBRK                                          *
      *                                                               *
      *  Calls    : SRCHKLIN                                          *
      *                                                               *
      *****************************************************************
 
     C     SRWP1END      BEGSR
 
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
 
     C                   Z-ADD     4             WRQDLN
     C                   EXSR      SRCHKLIN
 
      ** Write out Total Format by Selecting the NPV Method
 
     C                   SELECT
 
     C                   WHEN      PNPVM = 'N' OR
     C                             PNPVM = ' '
     C                   WRITE     TRAILP1T1
 
     C                   WHEN      PNPVM = 'F'
     C                   WRITE     TRAILP3T1
 
     C                   WHEN      PNPVM = 'B'
     C                   WRITE     TRAILP4T1
 
     C                   WHEN      PNPVM = 'D'
     C                   WRITE     TRAILP5T1
 
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFP1 - Register P1 Printer File via RCF                   *
      *                                                               *
      *  Called by: SROPNCLO                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRCFP1       BEGSR
 
      ** Ensure Report Spool File recorded by RCF
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQN
     C                   PARM                    PENTY
     C                   PARM                    SFILE
     C                   PARM                    SFNUM
     C                   PARM                    PERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program
 
     C                   IF        PERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAU - Register AU Printer File via RCF                   *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAU       BEGSR
 
      ** Ensure Audit Spool File recorded by RCF
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQN
     C                   PARM      *BLANKS       PENTY
     C                   PARM                    SFILEU
     C                   PARM                    SFNUMU
     C                   PARM      *BLANKS       PERR
 
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
 
     C                   IF        PERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFMTAMT - Format Printer File Fields Amount                 *
      *                                                               *
      *  Called by: SRMTHBRK                                          *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRFMTAMT      BEGSR
 
     C                   CALLB     'ZSEDITF'
     C                   PARM                    PINAMT
     C                   PARM                    PINDEC
     C                   PARM                    PINCODE
     C                   PARM      *BLANKS       PINCHAR
     C                   PARM      *BLANKS       POUTAMT
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Output Audit report and End Program                *
      *                                                               *
      *  Called by: Main Processing, SRPROCES, *PSSR                  *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRAUDIT       BEGSR
 
     C**********         OPEN      DL0420AU
 
      ** Output Report Header and File Controls
 
     C                   WRITE     HEADAU
     C                   WRITE     CONTROL
 
      ** If there is a DB Error, Output the DB Error Information
 
     C                   IF        *INU7 = *ON
     C                   WRITE     DBERROR
     C                   ELSE
 
      ** Or, if no records read, Output "No Details" message
 
     C                   IF        RCOUNT = 0
     C                   WRITE     NODTLS
     C                   ENDIF
     C                   ENDIF
 
      ** End Program and Return
 
     C                   CLOSE     DL0420AU
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation Routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : SRRCFAU                                           *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Receive entry parameters
 
     C     *ENTRY        PLIST
     C                   PARM                    PSEQN
     C                   PARM                    PBRCA
     C                   PARM                    PNPVM
 
      ** Initialise LDA field
 
     C                   EVAL      DBPGM = 'DL0420'
 
      ** Call Access Program for Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Handle Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 6
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              216940
      ** Call Access Program for Currency Details                                             216940
                                                                                              216940
     C                   CALL      'AOCURRR0'                                                 216940
     C                   PARM      *BLANKS       PRTCD                                        216940
     C                   PARM      '*KEY   '     POPTN                                        216940
     C                   PARM                    BJCYCD                                       216940
     C     SDCURR        PARM      SDCURR        DSSDY                                        216940
                                                                                              216940
     C                   IF        PRTCD <> *BLANKS                                           216940
     C     *LOCK         IN        LDA                                                        216940
     C                   EVAL      DBFILE = 'SDCURRPD'                                        216940
     C                   EVAL      DBASE = 7                                                  216940
     C                   EVAL      DBKEY = BJCYCD                                             216940
     C                   EVAL      *INU7 = *ON                                                216940
     C                   EVAL      *INU8 = *ON                                                216940
     C                   EVAL      *INLR = *ON                                                216940
     C                   OUT       LDA                                                        216940
     C                   EXSR      *PSSR                                                      216940
     C                   ELSE                                                                 216940
     C                   EVAL      WBsNBDP = A6NBDP                                           216940
     C                   ENDIF                                                                216940
 
      ** Access RUNDAT for multibranching indicator
 
     C                   IN        RUNDAT
 
     C                   IF        AGMBIN = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   ENDIF
 
     C                   OPEN      DL0420AU
 
      ** RCF Processing for Audit File
 
     C                   EXSR      SRRCFAU
 
      ** Initialize Amount and Work Fields
 
     C                   Z-ADD     0             WMEAMT
     C                   Z-ADD     0             WMDBCE
     C                   Z-ADD     0             WMREVA
     C                   Z-ADD     0             WMPRLA
     C                   Z-ADD     0             WYEAMT
     C                   Z-ADD     0             WYDBCE
     C                   Z-ADD     0             WYREVA
     C                   Z-ADD     0             WYPRLA
     C                   Z-ADD     0             WTEAMT
     C                   Z-ADD     0             WTDBCE
     C                   Z-ADD     0             WTREVA
     C                   Z-ADD     0             WTPROF
     C                   Z-ADD     0             WTLOSS
     C                   Z-ADD     0             WTPRLA
     C                   Z-ADD     0             WRQDLN
     C                   Z-ADD     0             WDIFLN
     C                   MOVE      *BLANKS       WBRCA
     C                   MOVE      *BLANKS       WCYCD
     C                   MOVE      *BLANKS       WBKCD
     C                   MOVE      *BLANKS       WMONTH
     C                   MOVE      *BLANKS       WYEAR
     C                   MOVE      'Y'           WFIRST
     C                   MOVE      'N'           WOPEN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls    : SRAUDIT                                           *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called
 
     C                   IF        WRUN = *BLANKS
     C                   MOVE      'Y'           WRUN
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2001
