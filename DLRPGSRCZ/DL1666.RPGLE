     H DEBUG
      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS deals bulk rate correction')              *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1666 - OIS Deal Bulk Rate Correction - Update              *
      *                                                               *
      *  Function:  Using the new Base Rate passed in from the prompt *
      *             program DL1667 this program recalculates and      *
      *             updates the Compounding Rate and the Interest     *
      *             Rate on the Compounding Interest File, PF/DLDOISPD*
      *                                                               *
      *  Called By: DLC1666 - OIS Deals Bulk Rate Correction Control  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 240334             Date 17Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CPK025             Date 08Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 BUG7016R           Date 01Mar06               *
      *                 BUG7016            Date 01Mar06               *
      *                 226723             Date 01Mar06               *
      *                 220859             Date 01Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 22Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CAS008             Date 16Jun06               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 217684             Date 12May03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 212248             Date 27Aug03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209171             Date 06Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      *                 CAP056             Date 13Mar02               *
      *                 CIR008             Date 13Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  CPK025 - add /COPY ZFEB29Z1LE and corrected definition of    *
      *           @@DAYN.                                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG7016R- Supply the missing lines of code fore BUG7016      *
      *  BUG7016- Increase number of decimal places for work fields   *
      *           used to calculate compound rate to 15               *
      *  226723 - Allow the insertion of negative base rates for OIS  *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1666 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *           Also fix divide by zero error caused by number of   *
      *           days since last payment date being zero.            *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CAS008 - IAS 39 Enhancements (Recompile)                     *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  217684 - Authorisation User Malfunction (Recompile)          *
      *  CAS004 - Hedge Accounting Phase A (Recompile)                *
      *  212248 - Extend length of work fields to 14,9 to allow for   *
      *           large rates and/or long term backvaluation.         *
      *  209171 - Error fix for 204923                                *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CAP056 - Automatic Authorisation of Interface deals          *
      *           (Recompile)                                         *
      *  CIR008 - FRA/IRS Deals Authorisation (Recompile)             *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDLOISGL0  UF   E           K DISK    COMMIT
     FDLDOISL1  UF   E           K DISK    COMMIT
     FDLOISSL3  IF   E           K DISK                                                       204923
     FDL1666P1  O    E             PRINTER
     F                                     INFDS(SPOOL1)
     FDL1666AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  37 - Report Trailer                                          *
      *  70 - READE DLOISGL0                                          *
      *  75 - READ  DLDOISL0                                          *
      *  76 - READ  DLDOISL0                                          *
      *  85 - READP DLDOISL0                                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRINIT   - Subroutine to do Program Initialisation.          *
      *  SRPROC   - Subroutine to do Detail Processing.               *
      *  SRONIS   - Subroutine to Process the OIS Compounding         *
      *             Interest Rate File, PF/DLDOISPD.                  *
      *  SRUPDT   - Subroutine to recalculates the compound rate and  *
      *             interest rate fields and then updates the         *
      *             OIS Compounding Interest Rate File PF/DLDOISPD    *
      *  SRRIMD   - Recalculate Interest Amount Due.                  *
      *  SRPRNT   - Subroutine to decide what format needs to be      *
      *             printed.                                          *
      *  SRNEWP   - Subroutine to print a new page.                   *
      *  SRRECD   - Subroutine to Write a Detail record to the Report.*
      *  SREND    - Subroutine to Write End of Report.                *
      *  SRCUST   - Subroutine to obtain customer details from file   *
      *             SDCUSTPD via logical file SDCUSTL1                *
      *  SRBRCH   - Subroutine to retrieve Branch Code and Branch     *
      *             Name from file SDBRCHPD                           *
      *  SRAUDT   - Subroutine to Output Audit report and End Program.*
      *  SRRCFA   - Subroutine to register DL1666AU via RCF.          *
      *  SRRCFP   - Subroutine to register DL1666P1 via RCF.          *
      *  *PSSR    - Program exception error routine.                  *
      *                                                               *
      *****************************************************************
      /EJECT
      *
      ** Array containing Copyright statement
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D*COPY ZSRSRC,ZDATE2Z1                                                                   220859
     D/COPY ZSRSRC,ZDATE2Z1LE                                                                 220859
      *                                                                                       204923
      ** Array for holiday checking                                                           204923
     D*COPY ZSRSRC,ZHOLE                                                               204923 220859
     D/COPY ZSRSRC,ZHOLELE                                                                    220859
     D*COPY ZSRSRC,ZDATE9Z1                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CIR013
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CPK025
      *
      ** Data structure for holiday checking                                                  204923
     D*COPY ZSRSRC,ZHOLI                                                               204923 220859
     D/COPY ZSRSRC,ZHOLILE                                                                    220859
      *                                                                                       204923
      /SPACE 3
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Program Status Data Structure
     D PSDS           SDS
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
      *
      ** Data Structure to receive Customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *
      ** Data Structure to receive Deal details
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      *
      ** Data Structure to receive bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Branch Details Data structure
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  ##DFAC       E                     EXTFLD(QQDFAC)                                     CGL029
      *
      ** Base Rate Details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** SAR Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       204923
      ** DS for Currency details                                                              204923
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  204923
      *
      ** DS for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** File Information Data Structure for DL1666P1.
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
      *
     D** File Information Data Structure for DL1666AU.
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
     D*COPY*ZSRSRC,ZDATE9Z2                                                                   CIR013
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CIR013
     D*COPY*ZSRSRC,ZINTDYZ1                                                                   CIR013
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 CIR013
     C/EJECT
      *================================================================
      *  P R O G R A M   S T A R T                                    *
      *================================================================
      *
      ** Perform Initialisation.
      *
     C                   EXSR      SRINIT
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Output Audit Report and End Program.
      *
     C                   EXSR      SRAUDT
      *
      ** Perform Termination Processing.
      *
     C                   SETON                                        LR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINIT - Initialisation subroutine                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : AOBANKR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRINIT        BEGSR
      *
      ** Set up copyright parameter
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
      ** Receive Parameter List
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PRLEV             1
     C                   PARM                    PRENT             3
     C                   PARM                    PCCY              3
     C                   PARM                    PDATE             6
     C                   PARM                    PCODE             2
     C                   PARM                    PBRATE           10
     C                   PARM                    PSIGN             1                          226723
      *
      ** Initialise LDA field.
      *
     C                   MOVEL     'DL1666'      DBPGM
      *
      ** Access Bank details via access program
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'SDBANKPD'    DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVEL     '*FIRST  '    DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVEL     BJURPT        RBANK
     C                   MOVEL     BJMRDT        RMRDT
      *
      ** Check System Date Format, DDMMYY (*IN98 off)
      *                            MMDDYY (*IN98 on).
     C     BJDFIN        IFEQ      'M'
     C                   SETON                                        98
     C                   ENDIF
      *
      ** RCF Processing for Printer File
      *
     C                   EXSR      SRRCFP
      *
      ** RCF Processing for Audit File.
      *
     C                   EXSR      SRRCFA
      *
      ** Report Work fields.
      *
     C                   Z-ADD     0             RQDLN1            3 0
     C                   Z-ADD     0             DIFLN1            3 0
      *
      ** Initialise all working fields
      *
     C                   Z-ADD     *ZERO         DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
      *
     C                   Z-ADD     *ZERO         RRCOUN            4 0
     C                   Z-ADD     *ZERO         RDCOUN            4 0
      *
      ** Convert the received Base Rate Date parameter from DDMMYY
      ** to Midas Day Number
      *
     C                   MOVE      PDATE         ZDATE
     C                   EXSR      ZDATE1
     C                   MOVE      ZDAYNO        WDATE             5 0
      *
      ** Convert the received Base Rate Code parameter into a
      ** numeric field.
      *
     C**********         MOVE      PCODE         WCODE             2 0                        CSD103
     C                   MOVE      PCODE         WCODE             2                          CSD103
      *
      ** Move the received branch code parameter into working field.
      *
     C                   MOVE      PRENT         WBRCA             3
      *
      ** Convert the received Base Rate parameter into numeric value.
      *
     C                   MOVE      PBRATE        WBRAT            10 7
      *                                                                                       226723
      ** Negate the rate if the sign field is negative.                                       226723
      *                                                                                       226723
     C     PSIGN         IFEQ      '-'                                                        226723
     C                   Z-SUB     WBRAT         WBRAT                                        226723
     C                   ENDIF                                                                226723
      *
      ** Access SDDEALPD, divide Hong Kong Tax rate field and divide
      ** by 100 to get working tax rate TAXR.
      *
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVE      'SDDEALPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     BNHKTR        DIV       100           TAXR              5 4
      *
      ** Check if switchable feature CIR004 is on
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CIR004'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF    '
     C     *LOCK         IN        LDA
     C                   Z-ADD     5             DBASE
     C                   MOVE      'SCSARDPD'    DBFILE
     C                   MOVEL     'CIR004'      DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR004            1
     C                   ELSE
     C                   MOVEL     'N'           CIR004
     C                   ENDIF
      *
      ** Set up partial Key List to access deals file.
      *
     C     KBRCHA        KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    BRCA
      *
      ** Set up a key list to the access records from PF/DLDOISPD
      *
     C     KONIS         KLIST
     C                   KFLD                    L1DLNO
     C                   KFLD                    L1OTCD
     C                   KFLD                    L1BSDT
      *
      ** Set up partial Key List to access deals file.
      *
     C     KDEAL         KLIST
     C                   KFLD                    UCUCY
     C                   KFLD                    BRCA
     C                   KFLD                    DLNO
      *
      ** Set up key list for OIS Deals Interest Rate File
      *
     C     KRIMD         KLIST
     C                   KFLD                    L1DLNO
     C                   KFLD                    L1OTCD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRPROC
      *****************************************************************
      *                                                               *
      *  SRPROC - Subroutine to do Detail Processing                  *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls    : AOBSRTR0, SREND, SRAUDT, SRCUST, SRBRCH, SRONIS   *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Using the recieved parameters for branch code and currency
      ** code, the file DEALSDG is read sequentially via logical
      ** file DLOISGL0. Logical File DLOISGL0 keyed on UCUCY, BRCA and
      ** DLNO with select on DTYP EQ 'RS' and RECI NE'M'.
      *
     C                   MOVE      PCCY          UCUCY
      *
     C     WBRCA         IFEQ      'ALL'
     C                   MOVE      *BLANKS       BRCA
     C                   ELSE
     C                   MOVE      WBRCA         BRCA
     C                   ENDIF
      *
     C     KBRCHA        SETLL     DLOISGL0
      *
      ** Read first record from file
      *
     C                   READ(N)   DLOISGL0                               70
      *
      ** Check if record found matches our search criteria.
      *
     C     WBRCA         IFEQ      'ALL'
     C     UCUCY         IFNE      PCCY
     C                   MOVEL     '1'           *IN70
     C                   ENDIF
     C                   ELSE
     C     UCUCY         IFNE      PCCY
     C     BRCA          ORNE      WBRCA
     C                   MOVEL     '1'           *IN70
     C                   ENDIF
     C                   ENDIF
      *
      ** If End of Records, (*IN70), Perform: Audit Reporting (No
      ** Records).
      *
     C     *IN70         IFEQ      *ON
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
      ** Retrieve branch details.
      *
     C                   EXSR      SRBRCH
      *
      ** Initialise OLD branch code field
      *
     C                   MOVE      *BLANKS       WBOLD             3
      *
      ** Logical file keyed so that it ignores all Matured deals
      ** and all the deals type that are NOT equall to RS.
      *
     C     *IN70         DOWEQ     *OFF
      *
      ** For all the deals that are not ignored, attempt to read the
      ** record for the deal on the OIS compounding Interest Rate file.
      *
     C                   MOVE      *BLANKS       RCRNM
      *
      ** Retrieve Customer details.
      *
     C                   EXSR      SRCUST
      *                                                                                       204923
      ** Access currency details using transaction currency.                                  204923
      *                                                                                       204923
     C                   MOVE      UCUCY         PCURR             3                          204923
      *                                                                                       204923
     C                   CALL      'AOCURRR0'                                                 204923
     C                   PARM      *BLANKS       PRTCD                                        204923
     C                   PARM      '*KEY   '     POPTN                                        204923
     C                   PARM                    PCURR                                        204923
     C     SDCURR        PARM      SDCURR        DSSDY                                        204923
      *                                                                                       204923
     C     PRTCD         IFNE      *BLANKS                                                    204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'SDCURRPD'    DBFILE                                       204923
     C                   Z-ADD     6             DBASE                                        204923
     C                   MOVEL     PCURR         DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C     A6FXDY        IFEQ      0                                                          204923
     C                   Z-ADD     BJRDNB        WTDAT             5 0                        204923
     C                   ELSE                                                                 204923
     C                   Z-ADD     A6FXDY        ZNRDYS                                       204923
     C                   MOVEL     BJLCCY        ZCCY                                         204923
     C                   Z-ADD     BJRDNB        ZDAYNO                                       204923
     C                   EXSR      ZBKDT                                                      204923
     C                   Z-ADD     ZDYNBR        WTDAT                                        204923
     C                   ENDIF                                                                204923
      *
      ** Ignore all 'RS' deals:
      ** - that are not OIS
      ** - that have not reached its value date.
      ** - where the date passed in as parameter is in a
      **   'CLOSED' interest period.
      ** - for which the base rate code on the OIS side does
      **   not match received parameter (if not blank) from DLC1666
      *
     C     UICFR         IFEQ      'O'
     C     VDAT          ANDLE     BJRDNB
     C     USLIP         ANDLT     WDATE
      *
     C*****WCODE         IFEQ      *ZERO                                                      CSD103
     C*****WCODE         ORNE      *ZERO                                                      CSD103
     C     WCODE         IFEQ      *BLANKS                                                    CSD103
     C     WCODE         ORNE      *BLANKS                                                    CSD103
     C     WCODE         ANDEQ     UBRTT
      *
     C                   MOVE      'O'           L1OTCD
     C                   EXSR      SRONIS
      *
     C                   ENDIF
     C                   ENDIF
      *
     C     TICFR         IFEQ      'O'
     C     VDAT          ANDLE     BJRDNB
     C     TSLIP         ANDLT     WDATE
      *
     C*****WCODE         IFEQ      *ZERO                                                      CSD103
     C*****WCODE         ORNE      *ZERO                                                      CSD103
     C     WCODE         IFEQ      *BLANKS                                                    CSD103
     C     WCODE         ORNE      *BLANKS                                                    CSD103
     C     WCODE         ANDEQ     TBRTT
      *
     C                   MOVE      'T'           L1OTCD
     C                   EXSR      SRONIS
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Store OLD Branch Code.
      *
     C                   MOVE      BRCA          WBOLD
      *
     C                   COMMIT
      *
     C                   READ(N)   DLOISGL0                               70
      *
      ** Check if record found matches our search criteria.
      *
     C     *IN70         IFEQ      *OFF
     C     WBRCA         IFEQ      'ALL'
     C     UCUCY         IFNE      PCCY
     C                   MOVEL     '1'           *IN70
     C                   ENDIF
     C                   ELSE
     C     UCUCY         IFNE      PCCY
     C     BRCA          ORNE      WBRCA
     C                   MOVEL     '1'           *IN70
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** End of file so write trailer
      *
     C                   EXSR      SREND
      *
      ** Produce Audit Report.
      *
     C                   EXSR      SRAUDT
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRONIS
      *****************************************************************
      *                                                               *
      *  SRONIS - Process PF/DLDOISPD                                 *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : SRUPDT, SRRIMD, SRPRNT                            *
      *                                                               *
      *****************************************************************
      *
     C     SRONIS        BEGSR
      *
     C                   Z-ADD     DLNO          L1DLNO
     C                   Z-ADD     WDATE         L1BSDT
      *
      ** For all the deals that are not ignored, attempt to read the
      ** record for the deal on the OIS compounding Interest Rate file.
      ** Logical file DLDOISL1 keyed on L1DLNO, L1OTCD and L1BSDT. L1BSDT
      ** is keyed in Decending order.
      *
     C     KONIS         CHAIN     DLDOISL1                           75
      *                                                                                       204923
      ** If A6FXDY NE 0, do not update if L1BSDT is equal to previous                         204923
      ** local working day.                                                                   204923
      *                                                                                       204923
     C     *IN75         IFEQ      *OFF                                                       204923
     C     A6FXDY        ANDNE     0                                                          204923
     C     L1BSDT        ANDEQ     WTDAT                                                      204923
      *                                                                                       204923
     C     L1DLNO        CHAIN     DLOISSL3                           75                      204923
     C     *IN75         IFEQ      '0'                                                        204923
     C     L5RFIN        ANDNE     'Y'                                                        204923
      *                                                                                       204923
     C     *IN75         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     L1OTCD        ANDEQ     'O'                                                        204923
     C     UNIPD         ANDNE     WTDAT                                                      204923
      *                                                                                       204923
     C     *IN75         OREQ      '0'                                                        204923
     C     L5RFIN        ANDEQ     'Y'                                                        204923
     C     L1OTCD        ANDEQ     'T'                                                        204923
     C     TNIPD         ANDNE     WTDAT                                                      204923
     C                   MOVE      '1'           *IN75                                        204923
     C                   ENDIF                                                                204923
     C                   ENDIF                                                                204923
      *
     C     *IN75         IFEQ      *OFF
      *
      ** Updates NOT required if the record is a 'GUESS' record.
      *
     C     L1RTYP        IFNE      'GUESS'
      *
      ** Updates NOT required if the record is a 'Compound' record.
      *
     C     L1RTYP        IFNE      'COMPOUND'
      *
      ** Recalculate the Compound Rate and Interest Rate and update
      ** the OIS Compounding Interest Rate File PF/DLDOISPD.
      *
     C                   EXSR      SRUPDT
      *
      ** Recalculate the Interest Amount Due.
      *
     C                   EXSR      SRRIMD
      *
      ** Print details of the deal affected by the change in Base Rate.
      *
     C                   EXSR      SRPRNT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRUPDT
      *****************************************************************
      *                                                               *
      *  SRUPDT - Recalculates the compound rate and interest rate    *
      *           fields and updates PF/DLDOISPD                      *
      *                                                               *
      *  Called By: SRONIS                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRUPDT        BEGSR
      *
      ** Update the present record with the new base rate.
      *
     C                   Z-ADD     WBRAT         L1BSRT
     C                   UPDATE    DLDOISD0
      *
      ** Save values of deal and side being processed. Used to test and
      ** exit from this processing loop.
      *
     C                   Z-ADD     L1DLNO        WDLNO             6 0
     C                   MOVEL     L1OTCD        WOTCD             1
      *
      ** Find the record just updated.
      *
     C     KONIS         CHAIN(N)  DLDOISL1                           75
      *
     C     *IN75         DOWEQ     *OFF
      *
      ** Save compounding rate from previous record.
      *
     C                   READ(N)   DLDOISL1                               75
      *
     C**********           Z-ADDL1CPRT    WCPRT  129                                          212248
     C**********           Z-ADDL1INRT    WINRT  129                                          212248
     C**********         Z-ADD     L1CPRT        WCPRT            14 9                 212248 220859
     C                   Z-ADD     L1CPRT        WCPRT            2015                        220859
     C**********         Z-ADD     L1INRT        WINRT            14 9                212248 BUG7016
     C                   Z-ADD     L1INRT        WINRT            2015                       BUG7016
      *
      ** Back to the current record again.
      *
     C                   READP     DLDOISL1                               75
      *
      ** Recalculate the compounding rate and interest rate fields.
      ** Apply spread to the old base rate on the deal
      *
     C                   Z-ADD     L1BSRT        WRATE            11 7
      *
      ** Spread for our side.
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     USPIN         IFEQ      'A'
     C     L1BSRT        ADD       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'S'
     C     L1BSRT        SUB       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'P'
     C     L1BSRT        MULT      URTSP         WORK             11 7
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Spread for their side
      *
     C     TSPIN         IFEQ      'A'
     C     L1BSRT        ADD       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'S'
     C     L1BSRT        SUB       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'P'
     C     L1BSRT        MULT      TRTSP         WORK
     C     WORK          DIV       100           WORK
     C     L1BSRT        ADD       WORK          WRATE
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Multiply the adjusted rate by the number of applicable days
      ** on the deals extension file.
      *
     C********** WRATE     MULT L1APDY    WRESA  129H                                         212248
     C*****WRATE****     MULT(H)   L1APDY        WRESA            14 9                212248 BUG7016
     C     WRATE         MULT(H)   L1APDY        WRESA            2015                       BUG7016
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
     C     UICBS         ANDEQ     9                                                          CIR013
     C     L1OTCD        ORNE      'O'                                                        CIR013
     C     TICBS         ANDEQ     9                                                          CIR013
      *                                                                                       CIR013
     C     L1OTCD        IFEQ      'O'                                                        CIR013
      * Our Last Interest Payment Date                                                        CIR013
     C                   Z-ADD     USLIP         @@DAYN            5 0                        CIR013
     C                   ELSE                                                                 CIR013
      * Their Last Interest Payment Date                                                      CIR013
     C                   Z-ADD     TSLIP         @@DAYN                                       CIR013
     C                   ENDIF                                                                CIR013
      *                                                                                       CIR013
      * Convert start date to YYYYMMDD format                                                 CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATA                                       CIR013
      *                                                                                       CIR013
      * Convert end date to YYYYMMDD format                                                   CIR013
     C                   Z-ADD     L1BSDT        @@DAYN                                       CIR013
     C                   EXSR      ZDATE9                                                     CIR013
     C                   Z-ADD     @@VDT         ZZDATB                                       CIR013
      *                                                                                       CIR013
      * Check for the existence of any February 29th within the dates                         CIR013
     C                   EXSR      #FEB29                                                     CIR013
     C                   ENDIF                                                                CIR013
      *
      ** Divide by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C********** WRESA     DIV  36500     WRESB  129H                                         212248
     C*****WRESA****     DIV(H)    36500         WRESB            14 9                212248 BUG7016
     C     WRESA         DIV(H)    36500         WRESB            2015                       BUG7016
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESA         DIV(H)    36500         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESA         DIV(H)    36000         WRESB
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESA         DIV(H)    36600         WRESB
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Add 1 to the result.
      *
     C********** WRESB     ADD  1         WRESC  129                                          212248
     C*****WRESB         ADD       1             WRESC            14 9               212248 BUG7016R
     C     WRESB         ADD       1             WRESC            2015                      BUG7016R
      *
      ** Multiply the result by the compounding rate from the previous
      ** record to get this records compounding rate.
      *
     C********** WRESC     MULT WCPRT     WRESD  129H                                         212248
     C*****WRESC***      MULT(H)   WCPRT         WRESD            14 9                212248 BUG7016
     C     WRESC         MULT(H)   WCPRT         WRESD            2015                       BUG7016
     C                   Z-ADD(H)  WRESD         L1CPRT
      *
      ** Subtract one from the result.
      *
     C********** WRESD     SUB  1         WRESE  129                                          212248
     C*****WRESD         SUB       1             WRESE            14 9                 212248 220859
     C     WRESD         SUB       1             WRESE            2015                        220859
      *
      ** Multiply by Our/Their Calculation Basis
      *
     C     L1OTCD        IFEQ      'O'
      *
     C     UICBS         IFEQ      1
     C     UICBS         OREQ      4
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C********** WRESE     MULT 36500     WRESF  129H                                         212248
     C*****WRESE         MULT(H)   36500         WRESF            14 9                 212248 220859
     C     WRESE         MULT(H)   36500         WRESF            2015                        220859
     C                   ENDIF
      *
     C     UICBS         IFEQ      2
     C     UICBS         OREQ      3
     C     UICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     UICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     UICBS         IFEQ      6
     C     UICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TICBS         IFEQ      1
     C     TICBS         OREQ      4
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C     WRESE         MULT(H)   36500         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      2
     C     TICBS         OREQ      3
     C     TICBS         OREQ      5
     C     CIR004        OREQ      'Y'
     C     TICBS         ANDEQ     7
     C     WRESE         MULT(H)   36000         WRESF
     C                   ENDIF
      *
     C     TICBS         IFEQ      6
     C     TICBS         OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     WRESE         MULT(H)   36600         WRESF
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Find number of days since last payment.
      *
     C     L1OTCD        IFEQ      'O'
     C     L1BSDT        SUB       USLIP         WNUMD             3 0
     C                   ELSE
     C     L1BSDT        SUB       TSLIP         WNUMD
     C                   ENDIF
      *
      ** Divide the result by the number of days since last interest
      ** payment date.
      *
     C********** WRESF     DIV  WNUMD     WRESG  129H                                         212248
     C*****WRESF         DIV(H)    WNUMD         WRESG            14 9                 212248 220859
     C     WNUMD         IFGT      0                                                          CIR013
     C     WRESF         DIV(H)    WNUMD         WRESG            2015                        220859
      *
      ** Update the extension file with this compound rate and interest
      ** rate.
      *
     C                   Z-ADD(H)  WRESG         L1INRT
     C                   ENDIF                                                                CIR013
      *
     C                   UPDATE    DLDOISD0
      *
      ** Count Number of records updated
      *
     C                   ADD       1             RRCOUN
      *
      ** READP reads forward (DLDOISL1 in Decending Date order).
      ** Get next record.
      *
     C                   READP     DLDOISL1                               75
      *
      ** Exit the loop when all records for the deal and side have been
      ** processed.
      *
     C     L1DLNO        IFNE      WDLNO
     C     L1OTCD        ORNE      WOTCD
     C                   MOVE      *ON           *IN75
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRRIMD
      *****************************************************************
      *                                                               *
      *  SRRIMD - Recalculates Interest Amount Due                    *
      *                                                               *
      *  Called by: SRONIS                                            *
      *                                                               *
      *  Calls    : DL1664                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRIMD        BEGSR
      *
      ** Load up the key with OLD deal
      *
     C                   Z-ADD     WDLNO         DLNO
      *
      ** Load up the key with OLD deal and side value.
      *
     C                   Z-ADD     WDLNO         L1DLNO
     C                   MOVEL     WOTCD         L1OTCD
      *
      ** Position to the last record on the file for the deal
      ** being amended.
      *
     C     KRIMD         SETLL     DLDOISL1                             75
     C                   READ      DLDOISL1                               75
      *
      ** Set the From Date to be either USLIP if Ours of TSLIP if Theirs.
      *
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     USLIP         PFDTE
     C                   ELSE
     C                   Z-ADD     TSLIP         PFDTE
     C                   ENDIF
      *
      ** If a settlement record then interest amount due needs
      ** recalculating. Call program DL1664 to calculate the base
      ** amount of interest due.
      *
     C     L1RTYP        IFEQ      'SETTLE'
     C                   CALL      'DL1664'
     C                   PARM      DLNO          PDEAL             6 0
     C                   PARM      L1OTCD        POTCD             1
     C                   PARM                    PFDTE             5 0
     C**********         PARM      BJRDNB        PRDNB             5 0                        209171
     C                   PARM      L1BSDT        PRDNB             5 0                        209171
     C                   PARM      *ZERO         PINTA            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     L1OTCD        IFEQ      'O'
     C                   ADD       UAIAN         PINTA
     C                   ADD       UAIAP         PINTA
     C                   ELSE
     C                   ADD       TAIAN         PINTA
     C                   ADD       TAIAP         PINTA
     C                   ENDIF
      *
      ** SETTLE records are also GUESS records for a succeeding interest
      ** period, so the compounding rate field must be set to 1.0.
      *
     C                   Z-ADD     1             L1CPRT
      *
      ** If the side is ours, the tax rate is not zero and the taxable
      ** indicator on the deal is 'Y' multiply the tax rate by the
      ** interest amount calculated above
      *
     C     L1OTCD        IFEQ      'O'
     C     TAXR          ANDNE     *ZERO
     C     TAXI          ANDEQ     'Y'
     C     TAXR          MULT(H)   PINTA         WRKTAX           15 0
     C     PINTA         SUB       WRKTAX        PINTA
     C                   ENDIF
      *
     C                   Z-ADD     PINTA         L1AMNT
      *
      ** Update OIS Compounding history file.
      *
     C                   UPDATE    DLDOISD0
      *
     C                   ENDIF
      *
      ** Update the Effective Interest Rate field in PF/DEALSDG with
      ** the latest Interest Rate.
      *
     C     KDEAL         CHAIN     DLOISGL0                           75
      *
     C     *IN75         IFEQ      *OFF
      *
     C     L1OTCD        IFEQ      'O'
     C                   Z-ADD     L1INRT        UEINR
     C                   ELSE
     C                   Z-ADD     L1INRT        TEINR
     C                   ENDIF
      *
     C                   UPDATE    DEALSDGF
      *
      ** Count the number of Deals affected
      *
     C                   ADD       1             RDCOUN
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRPRNT
      *****************************************************************
      *                                                               *
      *  SRPRNT - Determines what format is to be printed             *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : SRNEWP, SRRECD, SRBRCH                            *
      *                                                               *
      *****************************************************************
      *
     C     SRPRNT        BEGSR
      *
     C     RDCOUN        IFEQ      1
     C                   EXSR      SRNEWP
     C                   EXSR      SRRECD
      *
     C                   ELSE
      *
     C     BRCA          IFNE      WBOLD
     C                   SETON                                        37
     C                   WRITE     DL1666R4
     C                   CLOSE     DL1666P1
     C                   OPEN      DL1666P1
      *
      ** Retrieve Branch Code and Branch Name.
      *
     C                   EXSR      SRBRCH
      *
     C                   EXSR      SRNEWP
     C                   EXSR      SRRECD
      *
     C                   ELSE
      *
     C                   EXSR      SRRECD
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRNEWP
      *****************************************************************
      *                                                               *
      *  SRNEWP - Subroutine to print a new page.                     *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRNEWP        BEGSR
      *
      ** Populate the Header fields of the Report
      *
     C                   Z-ADD     WBRAT         RNEWR
     C                   MOVE      PCCY          RCURR
     C                   MOVE      PDATE         RBRDT
     C                   MOVE      PCODE         RCODE
      *
     C                   WRITE     DL1666R0
     C                   WRITE     DL1666R1
     C                   WRITE     DL1666R2
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRRECD
      *****************************************************************
      *                                                               *
      *  SRRECD - Writes 'detail' record to the report                *
      *                                                               *
      *  Called By: SRPRNT                                            *
      *                                                               *
      *  Calls    : ZDATE2                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRECD        BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     DL1666R0
     C                   WRITE     DL1666R2
     C                   ENDIF
      *
      ** Populate the remaining output fields and write out a detail
      ** record.
      *
     C     L1OTCD        IFEQ      'O'
      *
     C                   MOVEL(P)  'OUR'         RSIDE
      *
     C                   Z-ADD     USLIP         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RLIDT
      *
     C                   Z-ADD     UNIPD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RNIDT
      *
     C                   ELSE
      *
     C                   MOVEL     'THEIR'       RSIDE
      *
     C                   Z-ADD     TSLIP         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RLIDT
      *
     C                   Z-ADD     TNIPD         ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RNIDT
      *
     C                   ENDIF
      *
     C                   Z-ADD     DLNO          RDLNO
      *
      ** Convert Midas day number into DDMMYY format
      *
     C                   Z-ADD     DDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RDDAT
      *
     C                   Z-ADD     VDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RVDAT
      *
     C                   Z-ADD     MDAT          ZDAYNO
     C                   EXSR      ZDATE2
     C                   Z-ADD     ZDATE         RMDAT
      *
     C                   WRITE     DL1666R3
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SREND
      *****************************************************************
      *                                                               *
      *  SREND - Write 'End of Report'                                *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SREND         BEGSR
      *
      ** Check that sufficient lines remain for the Format. If not,
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     4             RQDLN1
     C     OFLLN1        SUB       PRTLN1        DIFLN1
     C     DIFLN1        IFLE      RQDLN1
     C                   WRITE     DL1666R0
     C                   ENDIF
      *
      ** Write Trailer
      *
     C                   SETON                                        37
     C                   WRITE     DL1666R4
     C                   SETOFF                                       37
     C                   WRITE     DL1666R4
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRCUST
      *****************************************************************
      *                                                               *
      *  SRCUST - Retrieve Customer details                           *
      *                                                               *
      *  Called By: SRPROC                                            *
      *                                                               *
      *  Calls    : AOCUSTR0                                          *
      *                                                               *
      *****************************************************************
      *
     C     SRCUST        BEGSR
      *
     C                   MOVE      *BLANKS       RCRNM
     C                   MOVEL     CNUM          PCNKY
      *
      ** Access Customer details
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    PCNKY            10
     C                   PARM                    PKYSTS            7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
      ** Database error if not found
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDCUSTPD'    DBFILE
     C                   MOVEL     PCNKY         DBKEY
     C                   Z-ADD     3             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      BBCRNM        RCRNM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRBRCH
      *****************************************************************
      *                                                               *
      *  SRBRCH - Retrieves Branch Code and Branch Name from SDBRCHPD *
      *                                                               *
      *  Called By: SRPROC and SRPRNT                                 *
      *                                                               *
      *  Calls    : AOBRCGR0, *PSSR                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRBRCH        BEGSR
      *
     C                   MOVE      *BLANKS       RBRCD
     C                   MOVE      *BLANKS       RBRNM
      *
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      BRCA          PBRKY             3
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
      ** Database error if not found
      *
     C     PRTCD         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVE      'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRKY         DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      A8BRCD        RBRCD
     C                   MOVE      A8BRNM        RBRNM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRAUDT
      *****************************************************************
      *                                                               *
      *  SRAUDT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, SRPROC, *PSSR                    *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     DL1666A0
     C                   WRITE     DL1666A1
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DL1666A3
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     RDCOUN        IFEQ      0
     C                   WRITE     DL1666A2
     C                   ENDIF
     C                   ENDIF
      *
      ** Write Trailer for Audit Report.
      *
     C                   WRITE     DL1666A4
      *
      ** End Program and Return.
      *
     C                   SETON                                        LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRRCFP
      *****************************************************************
      *                                                               *
      *  SRRCFP - Registers DL1666P1 via RCF                          *
      *                                                               *
      *  Called By: SRINIT                                            *
      *                                                               *
      *  Calls    : ZSFILE                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        ZSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT             3
     C                   PARM                    SFILE1
     C                   PARM                    ZSNUM
     C                   PARM      *BLANKS       ZSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/SRRCFA
      *****************************************************************
      *                                                               *
      *  SRRCFA - Registers DL1666AU via RCF                          *
      *                                                               *
      *  Called By: SRINIT                                            *
      *                                                               *
      *  Calls    : ZSFILE                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFA        BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        ZSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM                    PRENT
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUMU
     C                   PARM      *BLANK        ZSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/*PSSR
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   SETON                                        U7U8LR
     C                   DUMP
     C                   ROLBK
     C                   EXSR      SRAUDT
     C                   RETURN
     C                   ENDIF
      *
      ** If *PSSR already run, then just end the program here.
      *
     C                   SETON                                        U7U8LR
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      /TITLE SR/ZDATE1
     C*COPY ZSRSRC,ZDATE1Z2                                                                   220859
     C/COPY ZSRSRC,ZDATE1Z2LE                                                                 220859
      /EJECT
      /TITLE SR/ZDATE2
     C*COPY ZSRSRC,ZDATE2Z2                                                                   220859
     C/COPY ZSRSRC,ZDATE2Z2LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZBKDT                                                               204923 220859
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  220859
      /EJECT                                                                                  204923
     C*COPY ZSRSRC,ZACCH                                                               204923 220859
     C/COPY ZSRSRC,ZACCHLE                                                                    220859
      /EJECT                                                                                  204923
     C*COPY*ZSRSRC,ZDATE9Z3                                                                   CIR013
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CIR013
      /EJECT                                                                                  CIR013
     C*COPY*ZSRSRC,ZFEB29                                                                     CIR013
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CIR013
      /EJECT                                                                                  CIR013
**  CPY@
(c) Finastra International Limited 2001
**   ZYDY - YEARS IN DAYS CUMULATIVE, FOUR YEAR SPAN
0366073110961461
**   ZMDY - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
000031059090120151181212243273304334365
**   ZMNM - MONTHS SHORT NAMES
JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN                        CIR013
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR                           CIR013
00000000310005900090001200015100181002120024300273003040033400365
