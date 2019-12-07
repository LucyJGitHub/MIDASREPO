      *****************************************************************
/*STD *  RPGBASEBND                                                   *                       220859
/*EXI *  TEXT('Midas DL OIS Input Cycle Rate Fixing')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL1642 - OIS Deal Rate Fixing                                *
      *                                                               *
      *  Function:  This program processes records from PF/DLOISSPD,  *
      *             the OIS Settlement Control File, selecting        *
      *             records based on requirements passed on branch    *
      *             and currency parameters.For each deal represented,*
      *             the rate is fixed, the interest is calculated, and*
      *             a 'SETTLE' record is written to PF/DLDOISPD. A    *
      *             record for each deal is also written to report    *
      *             PF/DL1642P1.                                      *
      *                                                               *
      *  Called By: DLC1642 - OIS Deal Rate Fixing                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD051554           Date 28Sep18               *
      *  Prev Amend No. MD053295           Date 13Apr19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD047993           Date 23Sep17               *
      *                 MD035545           Date 11Sep15               *      
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CDL093             Date 08Apr14               *
      *                 AR996895           Date 25Nov12               *
      *                 263666             Date 01Feb10               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 246529             Date 30Apr07               *
      *                 246141             Date 26Mar07               *
      *                 240334             Date 17Jan07               *
      *                 264847             Date 30Nov06               *
      *                 BUG12990           Date 05Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 25Sep06               *
      *                 CDL049             Date 05Jul06               *
      *                 CPK025             Date 08Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 220859             Date 01Mar06               *
      *                 CDL038             Date 10May05               *
      *                 CIR013             Date 11Apr05               *
      *                 CDL028             Date 07Feb05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 204923             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CIR007  *CREATE    Date 11May01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD051554 - Leap Year Fix for interest calculation basis to   *
      *             be used for 1st Jan should not be present in      *
      *             FRA/IRS module                                    *
      *  MD053295 - Lending loan with Interest Calculation Basis      *
      *             method 3 (30/360) has wrong interest payment      *
      *             amount for month of March (Recompile)             *
      *  MD046248 - Finastra Rebranding                               *
      *  MD047993 - Modified MD035545. Removed dependency on Accrue   *
      *             on Last Day indicator.                            *
      *  MD035545 - LE: Interest Calculation in Leap year. Consider   *
      *             Accrue on Last Day Indicator for method 6.        *      
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL093 - MM Interest calculation type 9.                     *
      *           Amended to comply with changes added in /GLINTCZ1LE *
      *  AR996895 - Incorrect acrrual interest calculation            *
      *             (Child: AR996897) (Recompile)                     *
      *  263666 - Recompiled due to changes in ZINTDYZ2               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  246529 - Applied 1.2 core fix  241477                        *
      *  241477 - Amend work fields used in ZSEDITZLE.                *
      *  246141 - Recompiled due to changes in ZINTDYZ2               *
      *  240334 - Recompile over changes in ZACCHLE.                  *
      *  164847 - Recompile over changes in /COPY ZINTDYZ2LE.         *
      *  BUG12990 - Recompiled due to changes in ZINTDYZ2/ZINTDYZ2LE  *
      *  242286 - Recompile over changes in /COPY ZINTDYZ2LE.         *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CPK025 - Define #29FEB.                                      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  220859 - Increase the size of Compounding Rate from          *
      *           7 to 15 decimal places. DL1642 was converted to ILE *
      *           due to the change in the number of decimal places.  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CIR013 - Additional Calculation Method for FRA/IRS/CCF       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  204923 - Rate Fix Days Adjustment (OIS)                      *
      *  CIR007 - Overnight Index Swaps                               *
      *                                                               *
      *****************************************************************
     FDLOISSL4  UF   E           K DISK    COMMIT
      ** Logical file built over DLOISSPD - OIS Settlement Control File
      *
     FDEALS     IF   E           K DISK
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
     FDLDOISL1  UF   E           K DISK    COMMIT
      ** Logical file built over DLDOISPD - Deals OIS Details file
      *
     FDLCFSCPD  IF   E           K DISK
      ** Cash Flow Schedule file
      *
     FDLDTSCPD  IF   E           K DISK
      ** Date Schedule file
      *
     FDL1642P1  O    E             PRINTER USROPN
     F                                     INFDS(SPOOL1)
     FDL1642AU  O    E             PRINTER
     F                                     INFDS(SPOOLU)
      *****************************************************************
      *                                                               *
      *  F U N C T I O N   O F   I N D I C A T O R S                  *
      *                                                               *
      *  37 - Print 'END OF REPORT FOR BRANCH  ______'                *
      *  60 - Our side is an OIS and is being settled                 *
      *  61 - Their side is an OIS and is being settled               *
      *  70 - End of File Indicator DLOISSL4                          *
      *  71 - Chain Failed Indicator DEALS                            *
      *  72 - Error Occured while reading DEALS                       *
      *  74 - End of File Indicator DLDTSCPD, DLCFSCPD                *
      *  81 - Test Bit Result Indicator                               *
      *  86 - Test Bit Result Indicator                               *
      *                                                               *
      *****************************************************************
      /SPACE 3
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRPROC   - Detail Processing                                 *
      *  SRSELR   - Processing Selected Records                       *
      *  SRHEAD   - Process report heading for DL1642P1.              *
      *  SRNOIS   - Calculates Interest for the NON-OIS side          *
      *  SRNTUP   - Calculates Interest using UP FRONT method         *
      *             for THEIR NON-OIS side                            *
      *  SRNOUP   - Calculates Interest using UP FRONT method         *
      *             for OUR NON-OIS side                              *
      *  SRDNDT   - Determines the next rate change/payment date from *
      *             the date schedule file                            *
      *  SRTBRT   - Obtains details for THEIR Base Rate               *
      *  SROBRT   - Obtains details for OUR Base Rate                 *
      *  SRCALU   - Calculates Interest UP FRONT                      *
      *  SRCAYD -  Calculation if Interest Processing Method is 'Y'   *
      *  SRTSET   - Setup THEIR fields for THEIR processing           *
      *  SRUSET   - Setup OUR fields for OUR processing               *
      *  SRNTCF   - Calculates interest rate for THEIR non-OIS side   *
      *             using CASH FLOW Schedule method                   *
      *  SRNOCF   - Calculates interest rate for OUR non-OIS side     *
      *             using CASH FLOW Schedule method                   *
      *  SRDNCF   - Determines if interest is due today from the      *
      *             Cash Flow Schedule file                           *
      *  SRNINT   - Calculates interest using standard method for     *
      *             a non-OIS side that is settling today             *
      *  SRNETS   - Calculates the Net Settlement                     *
      *  SRREPT   - Report Processing                                 *
      *  SRENDP   - Termination Processing                            *
      *  SRAUDT   - Audit Processing                                  *
      *  SRRCFP   - RCF Processing for Printer File DL1642P1          *
      *  SRRCFA   - RCF Processing for Audit File DL1642AU            *
      *  *INZSR   - Program Initialisation                            *
      *  *PSSR    - Program exception error routine                   *
      *                                                               *
      *****************************************************************
      /EJECT
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      ** Array containing Copyright statement
      *
     D*COPY ZSRSRC,ZHOLE                                                               204923 220859
     D/COPY ZSRSRC,ZHOLELE                                                                    220859
      ** Array for holiday checking                                                           204923
      *                                                                                       204923
     D*COPY ZSRSRC,ZDATE9Z1                                                                   220859
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 220859
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
      /EJECT
     D*COPY ZSRSRC,ZSEDITZ1                                                                   220859
     D*COPY*ZSRSRC,ZSEDITZ1LE                                                          220859 241477
     D ZS2             S              1    DIM(21)                                            241477
      /EJECT
     D LDA           E DS           256    EXTNAME(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      *
     D WPARML          C                   CONST('LECalcBasis6LeapYear')                    MD035545
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
      ** Data Area giving Installation Control Details
      *
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** DUMMY RECORD FORMAT FOR DEAL DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** DUMMY RECORD FORMAT FOR BANK DETAILS
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** DUMMY RECORD FORMAT FOR CUSTOMER DETAILS
     D  #DFAC1       E                     EXTFLD(QQDFAC)                                     CGL029
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** DUMMY RECORD FORMAT FOR CURRENCY DETAILS
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      ** DUMMY RECORD FORMAT FOR BRANCH DETAILS
     D*SDGELR***     E DS                  EXTNAME(SDGELRPD)                       MD035545 MD047993
     D**ACCDQQ**     E                     EXTFLD(QQACCD)                          MD035545 MD047993
      *
     D*COPY ZSRSRC,ZHOLI                                                               204923 220859
     D/COPY ZSRSRC,ZHOLILE                                                                    220859
      ** Data structure for holiday checking                                                  204923
      *                                                                                       204923
     D PSDS           SDS
      ** Program Status Data Structure
      *
     D  PGM              *PROC
     D  WSID                 244    253
     D  USER                 254    263
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      ** Base Rate code details accessed via access program
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** DS for access programs, short Data Structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** second DS for access programs, long Data Structure
      *
     D SPOOL1          DS
      ** File Information Data Structure for DL1642P1.
      *
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
     D SPOOLU          DS
      ** File Information Data Structure for DL1642AU.
      *
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *                                                                                       CDL093
      ** Remove #29Feb as it is defined inside /COPY                                          CDL093
      *                                                                                       CDL093
     D***#29FEB*         S              1A                                             CPK025 CDL093
      /EJECT
     D*COPY ZSRSRC,ZSEDITZ2                                                                   220859
     D                 DS                                                                     220859
     D  WORK15                 1     15  0                                                    220859
     D  ZS1                    1     15  0                                                    241477
     D                                     DIM(15)                                            241477
      /EJECT
     D*COPY ZSRSRC,ZINTDYZ1                                                                   220859
     D/COPY ZSRSRC,ZINTDYZ1LE                                                                 220859
      /EJECT
     D*COPY ZSRSRC,ZDATE9Z2                                                                   220859
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 220859
      /EJECT
     D*COPY ZSRSRC,ZDAT10Z1                                                                   220859
     D/COPY ZSRSRC,ZDAT10Z1LE                                                                 220859
      *
      ****************************************************************
      *                M A I N   P R O C E S S I N G                 *
      ****************************************************************
      *
      ** Perform Detail Processing.
      *
     C                   EXSR      SRPROC
      *
      ** Create Audit Report
      *
     C                   EXSR      SRAUDT
      *
      ** Perform Termination Processing.
      *
     C                   EXSR      SRENDP
      *
      *****************************************************************
      *         E N D   O F   M A I N   P R O C E S S I N G           *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPROC - Detail Processing                                   *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     : SRSELR, SRHEAD                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRPROC        BEGSR
      *
      ** Build Key List DLOISS.
      *
     C                   MOVEL     PCURR         KCURR
     C     PENT          IFEQ      'ALL'
     C                   MOVEL     *BLANKS       KBRCA
     C                   ELSE
     C                   MOVEL     PENT          KBRCA
     C                   ENDIF
      *
      ** Position in file PF/DLOISSPD - OIS Settlement Control File.
      ** LF/DLOISSL4 key is CURR/BRCH/DLNO selecting only records
      ** where L5RFIN(Rate Fixed Indicator) is 'N'.
      *
     C     DLOISS        SETLL     DLOISSL4
      *
      ** Read first record from file (No lock).
      *
     C                   READ(N)   DLOISSL4                               70
      *
      ** Check if record found matches our search criteria.
      *
     C     PENT          IFEQ      'ALL'
     C     L5CURR        IFNE      PCURR
     C                   MOVEL     *ON           *IN70
     C                   ENDIF
     C                   ELSE
     C     L5CURR        IFNE      PCURR
     C     L5BRCA        ORNE      PENT
     C                   MOVE      *ON           *IN70
     C                   ENDIF
     C                   ENDIF
      *
      ** If the input file is empty, or the first record read does
      ** not match our search criteria, we blank out the branch code
      ** to give sensible headings.
      *
     C     *IN70         IFEQ      *ON
     C                   MOVEL     *BLANKS       L5BRCA
     C                   ENDIF
      *
     C                   EXSR      SRHEAD
      *
      ** Continue while records match search criteria.
      *
     C     *IN70         DOWEQ     *OFF
      *
      ** Process and Update the selected record.
      *
     C                   EXSR      SRSELR
      *
      ** Build Key List KYOISS.
      *
     C                   MOVE      L5CURR        KCURR
     C                   MOVE      L5BRCA        KBRCA
     C                   MOVE      L5DLNO        KDLNO
      *
     C     KYOISS        CHAIN     DLOISSL4                           73
     C                   MOVEL     'Y'           L5RFIN
     C                   UPDATE    DLOISSD0
     C                   COMMIT
      *
      ** Read the next record. (No Lock)
      *
     C                   READ(N)   DLOISSL4                               70
      *
      ** Check if record found matches search criteria.
      *
     C     *IN70         IFEQ      *OFF
     C     PENT          IFEQ      'ALL'
     C     L5CURR        IFNE      PCURR
     C                   MOVE      *ON           *IN70
     C                   ENDIF
     C                   ELSE
     C     L5CURR        IFNE      PCURR
     C     L5BRCA        ORNE      PENT
     C                   MOVE      *ON           *IN70
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** End read loop.
      *
     C                   ENDDO
      *
      ** Write trailer records for DL1642P1.
      *
     C                   MOVEL     *ON           *IN37
     C                   WRITE     TRAILER
     C                   MOVEL     *OFF          *IN37
     C                   WRITE     TRAILER
      *
      ** Close printer file DL1642P1.
      *
     C                   CLOSE     DL1642P1
      *
      ** End Subroutine SRPROC.
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSELR - Processing Selected Records                         *
      *                                                               *
      *  Called By : SRPROC                                           *
      *                                                               *
      *  Calls     : SRHEAD, SRNOIS, SRNETS, SRREPT, *PSSR, DL1646    *
      *              DL1662, DL1664                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRSELR        BEGSR
      *
      ** Check for a change of branch code.
      *
     C     PENT          IFEQ      'ALL'
     C     L5BRCA        IFNE      WOLBR
     C                   MOVEL     *ON           *IN37
     C                   WRITE     TRAILER
     C                   CLOSE     DL1642P1
     C                   EXSR      SRHEAD
     C                   ENDIF
     C                   ENDIF
      *
      ** Reset fields for new deal.
      *
     C                   Z-ADD     0             P@TINR
     C                   Z-ADD     0             P@OINR
     C                   Z-ADD     0             WOINT
     C                   Z-ADD     0             WTINT
     C                   Z-ADD     0             W#NTSL
     C                   MOVE      *OFF          *IN60
     C                   MOVE      *OFF          *IN61
      *
      ** Read PF/DEALSDG for the deal being settled.
      *
     C     L5DLNO        CHAIN     DEALS                              7172
      *
      ** Check for successful CHAIN.
      *
     C     *IN71         IFEQ      *ON
     C     *IN72         OREQ      *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     'DEALSDG'     DBFILE
     C                   MOVEL     L5DLNO        DBKEY
     C                   Z-ADD     4             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       204923
     C                   MOVEL     UCUCY         PCURR             3                          204923
      *                                                                                       204923
      ** Access Currency Details                                                              204923
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
     C                   Z-ADD     14            DBASE                                        204923
     C                   MOVEL     PCURR         DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C     A6FXDY        IFEQ      0                                                          204923
     C                   Z-ADD     BJRDNB        WDATE             5 0                        204923
     C                   ELSE                                                                 204923
     C                   Z-ADD     A6FXDY        ZNRDYS                                       204923
     C                   MOVEL     BJLCCY        ZCCY                                         204923
     C                   Z-ADD     BJRDNB        ZDAYNO                                       204923
     C                   EXSR      ZBKDT                                                      204923
     C                   Z-ADD     ZDYNBR        WDATE                                        204923
     C                   ENDIF                                                                204923
      *
      ** If our side of this deal is an OIS, and settling today.
      *
     C     UICFR         IFEQ      'O'
     C********** UNIPD     IFEQ BJRDNB                                                        204923
     C********** MDAT      OREQ BJRDNB                                                        204923
     C     UNIPD         IFEQ      WDATE                                                      204923
     C     MDAT          OREQ      WDATE                                                      204923
      *
      ** If the rate has already been fixed at least once for this deal
      ** today, then we do not need to recalculate it, only retrieve it
      ** from the DLDOISPD record for the deal.
      *
     C     L5RFIN        IFEQ      'Y'
      *
     C                   CALL      'DL1646'
     C                   PARM      DLNO          PDLNO             6 0
     C                   PARM      'O'           PSIDE             1
     C     PAMNT         PARM      *ZERO         PAMNT            13 0
     C                   PARM      *BLANKS       PRTCD             1
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   Z-ADD(H)  PAMNT         WOINT
     C                   ELSE
     C                   Z-ADD     *ZERO         WOINT
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN60
      *
     C                   ELSE
      *                                                                                       204923
     C     A6FXDY        IFEQ      0                                                          204923
      *
      ** This is the first request to fix the rate for this deal today.
      ** We calculate the amount for this side here.
      ** Call DL1662 to create and write a 'STANDARD' record to
      ** PF/DLDOISPD for this deal, side and today's date.
      *
     C                   CALL      'DL1662'
     C                   PARM      'O'           P@OTCD            1
     C                   PARM      DLNO          P@DLNO            6 0
     C                   PARM                    P@OINR           11 7
     C                   PARM      *BLANKS       P@RTCD            1
      *
      ** Check that DL1662 completed normally.
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1662'      DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       204923
     C                   ELSE                                                                 204923
      *                                                                                       204923
      ** Recalculate interest rate using the new rate                                         204923
      *                                                                                       204923
     C                   CALL      'DL1672'                                                   204923
     C                   PARM      DLNO          P@DLNO            6 0                        204923
     C                   PARM      'O'           P@OTCD            1                          204923
     C                   PARM                    P@OINR                                       204923
     C                   PARM      *BLANKS       P@RTCD                                       204923
      *                                                                                       204923
      ** Check that DL1672 completed normally.                                                204923
      *                                                                                       204923
     C     P@RTCD        IFNE      *BLANKS                                                    204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'DL1672'      DBFILE                                       204923
     C                   Z-ADD     15            DBASE                                        204923
     C                   MOVEL     '*CALL'       DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *
      ** Call DL1664 to calculate a Base Amount of Interest due
      ** for our side of the deal.
      *
     C                   CALL      'DL1664'
     C                   PARM      DLNO          P@DLNO
     C                   PARM      'O'           P@OTCD
     C                   PARM      USLIP         P@FRDT            5 0
     C**********           PARM BJRDNB    P@TODT  50                                          204923
     C                   PARM      WDATE         P@TODT            5 0                        204923
     C                   PARM                    P@OINT           13 0
     C                   PARM      *BLANKS       P@RTCD
      *
      ** Check that DL1664 completed norrmally.
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1664'      DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     P@OINT        WOINT            13 0
      *
      ** Add accrued Interest Adjusted Not Posted.
      *
     C     WOINT         ADD       UAIAN         WOINT
      *
      ** Add Accrued Interest Adjusted and Posted.
      *
     C     WOINT         ADD       UAIAP         WOINT
      *
      ** Apply tax if required.
      *
     C     WTAXR         IFNE      0
     C     TAXI          ANDEQ     'Y'
     C     WOINT         MULT(H)   WTAXR         WRKTAX           15 0
     C     WOINT         SUB       WRKTAX        WOINT
     C                   ENDIF
      *
      ** Update the record on PF/DLDOISPD just created by DL1662,
      ** making it a 'SETTLE' record. Note that 'SETTLE' records are
      ** also 'GUESS' records for the next interest period (if there
      ** is one) so the compounding rate field (L1CPRT) must be 1.
      *
      *
      ** Build Key List OISKY2.
      *
     C                   MOVE      DLNO          K@DLNO
     C                   MOVE      'O'           K@OTCD
      *
     C     OISKY2        SETLL     DLDOISL1
     C                   READ      DLDOISL1                               72
     C                   MOVEL(P)  'SETTLE'      L1RTYP
     C                   Z-ADD     WOINT         L1AMNT
     C                   Z-ADD     1             L1CPRT
     C                   UPDATE    DLDOISD0
      *
      ** Show that OIS record for Our side has been processed.
      *
     C                   MOVE      *ON           *IN60
      *
     C                   ENDIF
      *
      ** End of processing for our side of the deal, if an OIS.
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If Their Side of the deal is an OIS, and settling today.
      *
     C     TICFR         IFEQ      'O'
     C********** TNIPD     IFEQ BJRDNB                                                        204923
     C********** MDAT      OREQ BJRDNB                                                        204923
     C     TNIPD         IFEQ      WDATE                                                      204923
     C     MDAT          OREQ      WDATE                                                      204923
      *
      ** If the rate has already been fixed at least once for this deal
      ** today, then we do not need to recalculate it, only retrieve it
      ** from the DLDOISPD record for the deal.
      *
     C     L5RFIN        IFEQ      'Y'
      *
     C                   CALL      'DL1646'
     C                   PARM      DLNO          PDLNO             6 0
     C                   PARM      'T'           PSIDE             1
     C     PAMNT         PARM      *ZERO         PAMNT            13 0
     C                   PARM      *BLANKS       PRTCD
      *
     C     PRTCD         IFEQ      *BLANKS
     C                   Z-ADD(H)  PAMNT         WTINT
     C                   ELSE
     C                   Z-ADD     *ZERO         WTINT
     C                   ENDIF
      *
     C                   MOVE      *ON           *IN61
      *
     C                   ELSE
      *                                                                                       204923
     C     A6FXDY        IFEQ      0                                                          204923
      *
      ** This is the first request to fix the rate for this deal today.
      ** We calculate the amount for this side here.
      ** Call DL1662 to create and write a 'STANDARD' record to
      ** PF/DLDOISPD for this deal, side and today's date.
      *
     C                   CALL      'DL1662'
     C                   PARM      'T'           P@OTCD
     C                   PARM      DLNO          P@DLNO
     C                   PARM                    P@TINR
     C                   PARM      *BLANKS       P@RTCD
      *
      ** Check that DL1662 completed normally.
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1662'      DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                       204923
     C                   ELSE                                                                 204923
      *                                                                                       204923
      ** Recalculate interest rate using the new rate                                         204923
      *                                                                                       204923
     C                   CALL      'DL1672'                                                   204923
     C                   PARM      DLNO          P@DLNO            6 0                        204923
     C                   PARM      'T'           P@OTCD            1                          204923
     C                   PARM                    P@OINR                                       204923
     C                   PARM      *BLANKS       P@RTCD                                       204923
      *                                                                                       204923
      ** Check that DL1672 completed normally.                                                204923
      *                                                                                       204923
     C     P@RTCD        IFNE      *BLANKS                                                    204923
     C     *LOCK         IN        LDA                                                        204923
     C                   MOVEL     'DL1672'      DBFILE                                       204923
     C                   Z-ADD     16            DBASE                                        204923
     C                   MOVEL     '*CALL'       DBKEY                                        204923
     C                   OUT       LDA                                                        204923
     C                   EXSR      *PSSR                                                      204923
     C                   ENDIF                                                                204923
      *                                                                                       204923
     C                   ENDIF                                                                204923
      *
      ** Call DL1664 to calculate a Base Amount of Interest due
      *
     C                   CALL      'DL1664'
     C                   PARM      DLNO          P@DLNO
     C                   PARM      'T'           P@OTCD
     C                   PARM      TSLIP         P@FRDT
     C**********           PARM BJRDNB    P@TODT                                              204923
     C                   PARM      WDATE         P@TODT                                       204923
     C                   PARM                    P@TINT
     C                   PARM      *BLANKS       P@RTCD
      *
      ** Check that DL1664 completed normally.
      *
     C     P@RTCD        IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1664'      DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVEL     '*CALL'       DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   Z-ADD     P@TINT        WTINT            13 0
      *
      ** Add accrued Interest Adjusted Not Posted.
      *
     C     WTINT         ADD       TAIAN         WTINT
      *
      ** Add Accrued Interest Adjusted and Posted.
      *
     C     WTINT         ADD       TAIAP         WTINT
      *
      ** Update the record on PF/DLDOISPD just created by DL1662,
      ** making it a 'SETTLE' record. Note that 'SETTLE' records are
      ** also 'GUESS' records for the next interest period (if there
      ** is one) so the compounding rate field (L1CPRT) must be 1.
      *
      *
      ** Build Key List OISKY2.
      *
     C                   MOVE      DLNO          K@DLNO            6 0
     C                   MOVE      'T'           K@OTCD            1
      *
     C     OISKY2        SETLL     DLDOISL1
     C                   READ      DLDOISL1                               72
     C                   MOVEL(P)  'SETTLE'      L1RTYP
     C                   Z-ADD     WTINT         L1AMNT
     C                   Z-ADD     1             L1CPRT
     C                   UPDATE    DLDOISD0
      *
      ** Show that OIS record for Their side has been processed
      *
     C                   MOVE      *ON           *IN61
      *
     C                   ENDIF
      *
      ** End of processing for our side of the deal, if an OIS.
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** If our side of the deal is an OIS,and settlement is due today,
      ** the interest due will have been calculated above.If their side
      ** of the deal is not an OIS, settlement may also be due today,
      ** and the interest due will not have been calculated above.
      *
     C     *IN60         IFEQ      *ON
     C     TICFR         ANDNE     'O'
     C                   EXSR      SRNOIS
     C                   ENDIF
      *
      ** If their side of the deal is an OIS, and settlement is due
      ** today, the interest due will have been calculated above. If
      ** our side is not an OIS, settlement may also be due today,
      ** and the interest due will not have been calculated above.
      *
     C     *IN61         IFEQ      *ON
     C     UICFR         ANDNE     'O'
     C                   EXSR      SRNOIS
     C                   ENDIF
      *
      ** If at least one side is an OIS and settlement is due today
      ** calculate the NET INTEREST amount and write a record to
      ** report.
      *
     C     *IN60         IFEQ      *ON
     C     *IN61         OREQ      *ON
     C                   EXSR      SRNETS
     C                   EXSR      SRREPT
     C                   ENDIF
      *
      ** End of subroutine SRSELR.
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHEAD - Process Report Heading for DL1642P1                 *
      *                                                               *
      *  Called By : SRPROC, SRSELR                                   *
      *                                                               *
      *  Calls     : SRRCFP, AOBRCHR0, *PSSR                          *
      *                                                               *
      *****************************************************************
      *
     C     SRHEAD        BEGSR
      *
      ** Open printer file for DL1642P1.
      *
     C                   OPEN      DL1642P1
      *
      ** Register report to RCF.
      *
     C                   EXSR      SRRCFP
      *
      ** Get name of new branch for report headings.
      *
     C     L5BRCA        IFNE      *BLANKS
     C**********           CALL 'AOBRCHR0'                                                    CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRTNC
     C                   PARM      '*KEY'        POPTN
     C                   PARM      L5BRCA        PBRKY             3
     C**********           PARM           SDBRCH                                              CGL029
     C                   PARM                    DSSDY                                        CGL029
      *
      ** Check that AOBRCHR0 completed normally.
      *
     C     PRTNC         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   MOVEL     PBRKY         DBKEY
     C                   Z-ADD     9             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
      ** Load Report Heading Fields.
      *
     C                   MOVEL     L5BRCA        RBRCD
     C     L5BRCA        IFNE      *BLANKS
     C                   MOVEL     A8BRNM        RBRNM
     C                   ELSE
     C                   MOVEL     *BLANKS       RBRNM
     C                   ENDIF
      *
      ** Write DL1642P1 header records.
      *
     C                   WRITE     PGHEADER
     C                   WRITE     DTHEADER
      *
      ** Save new branch codes for future comparisons.
      *
     C                   MOVEL     L5BRCA        WOLBR             3
      *
      ** End subroutine SRHEAD.
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOIS - Calculates Interest for the NON-OIS side            *
      *                                                               *
      *  Called By : SRSELR                                           *
      *                                                               *
      *  Calls     : SRNOUP, SRDNCF, SRNOCF, SRNINT, SRNTUP, SRNTCF   *
      *                                                               *
      *****************************************************************
      *
     C     SRNOIS        BEGSR
      *
      **  Define Fields For Subroutine
      *
     C                   Z-ADD     0             WUEDAT            5 0
     C                   Z-ADD     0             WTEDAT            5 0
     C                   Z-ADD     0             WEINTR           15 2
     C                   Z-ADD     0             WUINOT           13 0
     C                   Z-ADD     0             WINTD            13 0
     C                   Z-ADD     0             WTAXC            15 0
     C                   Z-ADD     0             WTAX             13 0
     C                   Z-ADD     0             WENDDT            5 0
     C                   MOVE      *BLANK        WUBACK            1
     C                   Z-ADD     0             WDAYNO            5 0
      *
      ** OUR side of the deal is not an OIS
      *
     C     UICFR         IFNE      'O'
      *
      ** Determine whether interest is payable UP FRONT
      ** D- Discount, Y- Yield
      *
     C     UINPM         IFEQ      'D'
     C     UINPM         OREQ      'Y'
      *
     C     UNIPD         IFEQ      BJRDNB
     C     MDAT          OREQ      BJRDNB
      *
      ** Calculate the Interest due using the UP FRONT method.
      *
     C                   EXSR      SRNOUP
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Determine if interest is payable according to a
      ** CASH FLOW schedule.
      *
     C     UIPFR         IFEQ      'C'
      *
      ** Check if Interest is due today.
      *
     C                   MOVEL     'U'           OTIN
      *
     C                   EXSR      SRDNCF
      *
     C     *IN74         IFEQ      '0'
      *
      ** Calculate the Interest due using the CASH FLOW method
      *
     C                   EXSR      SRNOCF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The interest for this side of the deal is NOT payable
      ** Up Front and NOT payable according a Cash Flow Schedule.
      *
     C     UIPFR         IFNE      'C'
      *
     C     UINPM         IFNE      'D'
     C     UINPM         ANDNE     'Y'
      *
      ** Check if Interest is due today.
      *
     C     UNIPD         IFEQ      BJRDNB
     C     MDAT          OREQ      BJRDNB
      *
     C                   EXSR      SRNINT
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** THEIR side of the deal is not an OIS
      *
     C     TICFR         IFNE      'O'
      *
      ** Determine whether interest is payable UP FRONT
      *
     C     TINPM         IFEQ      'D'
     C     TINPM         OREQ      'Y'
      *
      ** Check if Interest is due today.
      *
     C     TNIPD         IFEQ      BJRDNB
     C     MDAT          OREQ      BJRDNB
      *
      ** Calculate the Interest due using the UP FRONT method.
      *
     C                   EXSR      SRNTUP
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Determine if interest is payable according to a
      ** CASH FLOW schedule.
      *
     C     TIPFR         IFEQ      'C'
      *
     C                   MOVEL     'T'           OTIN
      *
     C                   EXSR      SRDNCF
      *
     C     *IN74         IFEQ      '0'
      *
      ** Calculate the Interest due using the CASH FLOW method
      *
     C                   EXSR      SRNTCF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** The interest for this side of the deal is not payable
      ** Up Front and not payable according a Cash Flow Schedule.
      *
     C     TIPFR         IFNE      'C'
      *
     C     TINPM         IFNE      'D'
     C     TINPM         ANDNE     'Y'
      *
      ** Check if Interest is due today.
      *
     C     TNIPD         IFEQ      BJRDNB
     C     MDAT          OREQ      BJRDNB
     C                   EXSR      SRNINT
     C                   ENDIF
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
      *****************************************************************
      *                                                               *
      *  SRNTUP - Calculates Interest using Up Front Method for Their *
      *           Non-OIS side                                        *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : SRTSET, SRDNDT, SRTBRT, GLINTC, SRCALU           *
      *                                                               *
      *****************************************************************
      *
     C     SRNTUP        BEGSR
      *
     C                   EXSR      SRTSET
      *
     C                   TESTB     '1'           ACEI                 86
      *
      ** If value date of deal has not yet arrived
      *
     C     *IN86         IFEQ      *ON
      *
      ** Their first interest payment date is value date
      ** and their interest end date is the next interest payment date
      *
     C                   Z-ADD     VDAT          WTEDAT
      *
     C                   ENDIF
      *
     C                   MOVE      *BLANK        WTBACK            1
      *
      ** Their interest end date is the following interest payment date
      *
     C                   MOVEL     'T'           OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     WTEDAT        WDAYNO
      *
     C                   EXSR      SRDNDT
      *
     C                   Z-ADD     WDAYNO        TNEDT             5 0
      *
      ** If interest is up front, any interest payments from previous
      ** periods will already have been made therefore pay interest
      ** for current period only.
      *
     C     TNEDT         DOWLE     BJRDNB
     C                   Z-ADD     TNEDT         WTEDAT
     C                   Z-ADD     WTEDAT        WDAYNO
      *
     C                   EXSR      SRDNDT
      *
     C                   Z-ADD     WDAYNO        TNEDT
     C                   MOVE      'Y'           WTBACK
      *
     C                   ENDDO
      *
     C                   EXSR      SRTBRT
      *
     C     TNICD         IFNE      0
     C     WTEDAT        ANDGT     TNICD
      *
      ** Use SR:GLINTC to calculate the end interest from the interest
      ** change date up to but excluding the event date
      *
     C                   Z-ADD     WRATE         ZIRATE
      *
     C                   Z-ADD     TICBS         ZICALC
     C                   Z-ADD     TNICD         ZIBEG
     C                   Z-ADD     WTEDAT        ZIEND
     C                   Z-ADD     TPAMT         ZIAMT
      *
     C                   EXSR      GLINTC
      *
     C                   Z-ADD     ZINTR         WEINTR
      *
     C                   ELSE
      *
      ** Otherwise zeroise end interest
      *
     C                   Z-ADD     0             WEINTR
      *
     C                   ENDIF
      *
      ** Calculate the amount of interest due
      *
     C                   EXSR      SRCALU
      *
      ** Add the End Interest to the Interest due.
      *
     C     WINTD         ADD       WEINTR        WEINTR
      *
      ** The interest amount field on the report (RTINT) is set to the
      ** amount of interest due for a non-OIS RS deal with interest
      ** payable up front (WEINTR).
      *
     C                   Z-ADD     WEINTR        WTINT
      *
      ** The rate field on the report (RTINR) is set to the interest
      ** rate applicable to this side of the deal (RATE).
      *
     C                   Z-ADD     WRATE         P@TINR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOUP - Calculates Interest using Up Front Method for Our   *
      *           Non-OIS side                                        *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : SRUSET, SRDNDT, SROBRT, GLINTC, SRCALU           *
      *                                                               *
      *****************************************************************
      *
     C     SRNOUP        BEGSR
      *
     C                   EXSR      SRUSET
      *
     C                   TESTB     '1'           ACEI                 86
      *
      ** If value date of deal has not yet arrived
      *
     C     *IN86         IFEQ      *ON
      *
      ** OUR first interest payment date is value date
      ** and OUR interest end date is the next interest payment date
      *
     C                   Z-ADD     VDAT          WUEDAT
      *
     C                   ENDIF
      *
      ** OUR interest end date is the following interest payment date
      *
     C                   MOVEL     'U'           OTIN
     C                   MOVEL     'P'           RCIP
     C                   Z-ADD     WUEDAT        WDAYNO
      *
     C                   EXSR      SRDNDT
      *
     C                   Z-ADD     WDAYNO        UNEDT             5 0
      *
      ** If interest is up front, any interest payments from previous
      ** periods will already have been made therefore pay interest
      ** for current period only.
      *
     C     UNEDT         DOWLE     BJRDNB
     C                   Z-ADD     UNEDT         WUEDAT
     C                   Z-ADD     WUEDAT        WDAYNO
      *
     C                   EXSR      SRDNDT
      *
     C                   Z-ADD     WDAYNO        UNEDT
     C                   MOVE      'Y'           WUBACK
      *
     C                   ENDDO
      *
     C                   EXSR      SROBRT
      *
     C     UNICD         IFNE      0
     C     WUEDAT        ANDGT     UNICD
      *
      ** Use SR:GLINTC to calculate the end interest from the interest
      ** change date up to but excluding the event date
      *
     C                   Z-ADD     WRATE         ZIRATE
      *
     C                   Z-ADD     UICBS         ZICALC
     C                   Z-ADD     UNICD         ZIBEG
     C                   Z-ADD     WUEDAT        ZIEND
     C                   Z-ADD     UPAMT         ZIAMT
      *
     C                   EXSR      GLINTC
      *
     C                   Z-ADD     ZINTR         WEINTR
      *
     C                   ELSE
      *
      **  Otherwise zeroise end interest
      *
     C                   Z-ADD     0             WEINTR
      *
     C                   ENDIF
      *
      ** Calculate the amount of interest due
      *
     C                   EXSR      SRCALU
      *
      ** Add the End Interest to the Interest due.
      *
     C     WINTD         ADD       WEINTR        WEINTR
      *
      **  If the deal is tax payable calculate the tax on the interest
      **  due
      *
     C     TAXI          IFEQ      'Y'
     C     WEINTR        MULT(H)   BNHKTR        WTAXC
     C     WTAXC         DIV       100           WTAX
     C                   ENDIF
      *
      **  Calculate the interest net of tax (our interest amount)
      *
     C     WEINTR        SUB(H)    WTAX          WUINOT
      *
      ** The interest amount field on the report (ROINT) is set to the
      ** amount of interest due for a non-OIS RS deal with interest
      ** payable up front (WUINOT.)
      *
     C                   Z-ADD     WUINOT        WOINT
      *
      ** The rate field on the report (ROINR ) is set to the interest
      ** rate applicable to this side of the deal (RATE).
      *
     C                   Z-ADD     WRATE         P@OINR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDNDT - Determines the next rate change/payment date from   *
      *           the date schedule file                              *
      *                                                               *
      *  Called By : SRNOUP, SRNTUP                                   *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDNDT        BEGSR
      *
     C                   Z-ADD     WDAYNO        PRDT
      *
      ** Build Key List IRSDTL.
      *
     C                   MOVE      DLNO          KDEAL
     C                   MOVE      OTIN          KOTIN
     C                   MOVE      RCIP          KRCIP
     C                   MOVE      PRDT          KPRDT
      *
     C     IRSDTL        SETGT     DLDTSCPD
      *
      ** Build Key List IRSDTP.
      *
     C                   MOVE      DLNO          KDEAL
     C                   MOVE      OTIN          KOTIN
     C                   MOVE      RCIP          KRCIP
      *
     C     IRSDTP        READE     DLDTSCPD                               74
      *
     C     *IN74         IFEQ      *OFF
     C                   Z-ADD     PRDT          WDAYNO
     C                   ELSE
     C                   Z-ADD     MDAT          WDAYNO
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTBRT - Obtains details for Their Base Rate                 *
      *                                                               *
      *  Called By : SRNTUP                                           *
      *                                                               *
      *  Calls     : AOBSRTR0, *PSSR                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRTBRT        BEGSR
      *
      ** Define Fields for Subroutine
      *
     C                   Z-ADD     0             WBRDAT            5 0
     C                   Z-ADD     0             WRATE            11 7
     C                   Z-ADD     0             WPCNT            13 7
     C                   MOVE      *BLANKS       WKEY2             5
      *
     C                   MOVE      TBRTT         WKEY2
     C                   MOVEL     TCUCY         WKEY2
      *
      ** WKEY2 only used in case of DB error to set up LDA
      *
      ** Since TBRTT is a 2N field, move it to a 2A work field
      ** for call to access object
      *
     C                   MOVE      TBRTT         PTBRTT            2
      *
      ** Get details for Their Base Rate Type/Currency using call
      ** to access object
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     PRETN
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      TCUCY         PTCUCY            3
     C                   PARM                    PTBRTT
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      ** Handle database error
      *
     C     PRETN         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     10            DBASE
     C                   MOVE      'SDBSRTPD'    DBFILE
     C                   MOVEL     WKEY2         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain current Base Rate unless new value date of rate change
      ** is less than or equal to the fix date in which case obtain
      ** new base rate.
      *
     C     BAVDNR        IFLE      TINFD
     C                   Z-ADD     BANBRT        WRATE
     C                   Z-ADD     BAVDNR        WBRDAT
     C                   ENDIF
      *
     C     WRATE         IFEQ      0
     C                   Z-ADD     BACBSR        WRATE
     C                   Z-ADD     BAVDRC        WBRDAT
     C                   ENDIF
      *
     C                   Z-ADD     WRATE         BBRTE            11 7
      *
      **  Calculate the new effective interest rate.
      *
     C     TSPIN         IFEQ      'A'
     C     WRATE         ADD       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'S'
     C     WRATE         SUB       TRTSP         WRATE
     C                   ENDIF
      *
     C     TSPIN         IFEQ      'P'
     C     WRATE         MULT      TRTSP         WPCNT
     C     WPCNT         DIV       100           WPCNT
     C     WRATE         ADD       WPCNT         WRATE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SROBRT - Obtains details for Our Base Rate                   *
      *                                                               *
      *  Called By : SRNOUP                                           *
      *                                                               *
      *  Calls     : AOBSRTR0, *PSSR                                  *
      *                                                               *
      *****************************************************************
      *
     C     SROBRT        BEGSR
      *
      **  Define Fields for Subroutine
      *
     C                   Z-ADD     0             WBRDAT            5 0
     C                   Z-ADD     0             WRATE            11 7
     C                   Z-ADD     0             WPCNT            13 7
     C                   MOVE      *BLANKS       WKEY2             5
      *
     C                   MOVE      UBRTT         WKEY2
     C                   MOVEL     UCUCY         WKEY2
      *
      ** WKEY2 only used in case of DB error to set up LDA
      *
      *
      ** Since UBRTT is a 2N field, move it to a 2A work field
      ** for call to access object
      *
     C                   MOVE      UBRTT         PUBRTT            2
      *
      ** Get details for Our Base Rate Type/Currency using call
      ** to access object
      *
     C                   CALL      'AOBSRTR0'
     C                   PARM      '*MSG   '     PRETN
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      UCUCY         PUCUCY            3
     C                   PARM                    PUBRTT
     C     SDBSRT        PARM      SDBSRT        DSSDY
      *
      ** Handle database error
      *
     C     PRETN         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   Z-ADD     11            DBASE
     C                   MOVE      'SDBSRTPD'    DBFILE
     C                   MOVEL     WKEY2         DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Obtain current Base Rate unless new value date of rate change
      ** is less than or equal to the fix date in which case obtain
      ** new base rate.
      *
     C     BAVDNR        IFLE      UINFD
     C                   Z-ADD     BANBRT        WRATE
     C                   Z-ADD     BAVDNR        WBRDAT
     C                   ENDIF
      *
     C     WRATE         IFEQ      0
     C                   Z-ADD     BACBSR        WRATE
     C                   Z-ADD     BAVDRC        WBRDAT
     C                   ENDIF
      *
     C                   Z-ADD     WRATE         BBRTE            11 7
      *
      ** Calculate the new effective interest rate.
      *
     C     USPIN         IFEQ      'A'
     C     WRATE         ADD       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'S'
     C     WRATE         SUB       URTSP         WRATE
     C                   ENDIF
      *
     C     USPIN         IFEQ      'P'
     C     WRATE         MULT      URTSP         WPCNT
     C     WPCNT         DIV       100           WPCNT
     C     WRATE         ADD       WPCNT         WRATE
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCALU - Calculates Interest Up Front                        *
      *                                                               *
      *  Called By : SRNTUP, SRNOUP                                   *
      *                                                               *
      *  Calls     : GLINTC, SRCAYD                                   *
      *                                                               *
      *****************************************************************
      *
     C     SRCALU        BEGSR
      *
      ** Calculate interest from interest accrual control date
      ** to end date (this payment date to next payment date).
      *
     C                   Z-ADD     WZAICD        ZIBEG
     C                   Z-ADD     WZEDAT        ZIEND
     C                   Z-ADD     WZPPL         ZIAMT
     C                   Z-ADD     WZINR         ZIRATE
     C                   Z-ADD     WZCBS         ZICALC
      *
     C                   EXSR      GLINTC
      *
      ** If interest is YIELD based (method is 'Y') calculate it
      ** using information provided by GLINTC.
      *
     C     WZINPM        IFEQ      'Y'
     C                   EXSR      SRCAYD
     C                   ENDIF
      *
      ** Add interest accrued to control date, accrued interest
      ** adjustments not Posted, accrued interest adjustments posted
      ** and this interest amount to obtain the accrued interest to date
      *
     C     WZIACD        ADD       WZIANP        WZAITD           13 0
     C                   ADD       WZAIAP        WZAITD           13 0
     C                   ADD(H)    ZINTR         WZAITD
      *
      ** Subtract interest Paid/Received to date from accrued interest
      ** to date to give interest due.
      *
     C     WZAITD        SUB       WZIPRD        WINTD
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCAYD -  Calculation if Interest Processing Method is 'Y'   *
      *                                                               *
      *  Called By : SRCALU                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRCAYD        BEGSR
      *
      ** INTEREST = PRINCIPAL ( 1 - 1 / ( 1 + RATE X NUMBER OF DAYS/360))
      **       I.E. PRINCIPAL ( 1 - 360 / ( 360 + RATE X NUMBER OF DAYS))
      *
     C     ZICALC        IFEQ      2
     C     ZICALC        OREQ      3
     C     ZICALC        OREQ      5
     C     CIR004        OREQ      'Y'
     C     ZICALC        ANDEQ     7
     C                   Z-ADD     36000         ZIWRK3            5 0
      *
     C                   ELSE
      *
     C     ZICALC        IFEQ      1
     C     ZICALC        OREQ      4
     C     ZICALC        OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'N'                                                        CIR013
     C                   Z-ADD     36500         ZIWRK3
     C                   ELSE
     C                   Z-ADD     36600         ZIWRK3
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ZICALC        IFEQ      6                                                          CIR013
     C     ZICALC        OREQ      9                                                          CIR013
     C     #29FEB        ANDEQ     'Y'                                                        CIR013
     C     INT6DY        MULT      ZIRATE        ZIWRK4           15 7                        CIR013
     C                   ELSE                                                                 CIR013
     C     ZZINDY        MULT      ZIRATE        ZIWRK4           15 7
     C                   ENDIF                                                                CIR013
     C                   ADD       ZIWRK3        ZIWRK4
      *
     C     ZIWRK3        DIV(H)    ZIWRK4        ZIWRK5           15 9
     C     1             SUB       ZIWRK5        ZIWRK5
     C     ZIAMT         MULT(H)   ZIWRK5        ZINTR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTSET -  Setup THEIR fields for THEIR processing            *
      *                                                               *
      *  Called By : SRNTUP                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRTSET        BEGSR
      *
     C                   Z-ADD     TPAMT         WZPPL
     C                   Z-ADD     TEINR         WZINR
     C                   Z-ADD     TICBS         WZCBS
     C                   Z-ADD     TIALC         WZLICD
     C                   Z-ADD     TAITC         WZIACD
     C                   Z-ADD     TAIAN         WZIANP
     C                   Z-ADD     TAIAP         WZAIAP
     C                   Z-ADD     TAIPD         WZIPTD
     C                   Z-ADD     TIPRD         WZIPRD
     C                   Z-ADD     TIACD         WZAICD
      *
     C     WTBACK        IFEQ      'Y'
     C                   Z-ADD     WTEDAT        WZAICD
     C                   ENDIF
      *
     C                   TESTB     '3'           TDSTI                    81
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      'Y'           WZAVRM
     C                   ELSE
     C                   MOVE      'N'           WZAVRM
     C                   ENDIF
      *
     C                   Z-ADD     WENDDT        WZEDAT
     C                   Z-ADD     SDCAR         WZSDCR
     C                   MOVEL     'R'           WZDIR
     C                   MOVEL     TIPFR         WZIPFC
     C                   MOVEL     TINPM         WZINPM
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUSET -  Setup OUR fields for OUR processing                *
      *                                                               *
      *  Called By : SRNOUP                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRUSET        BEGSR
      *
     C                   Z-ADD     UPAMT         WZPPL            13 0
     C                   Z-ADD     UEINR         WZINR            11 7
     C                   Z-ADD     UICBS         WZCBS             1 0
     C                   Z-ADD     UIALC         WZLICD           13 0
     C                   Z-ADD     UAITC         WZIACD           13 0
     C                   Z-ADD     UAIAN         WZIANP           13 0
     C                   Z-ADD     UAIAP         WZAIAP           13 0
     C                   Z-ADD     UAIPD         WZIPTD           13 0
     C                   Z-ADD     UIPRD         WZIPRD           13 0
     C                   Z-ADD     UIACD         WZAICD            5 0
      *
     C     WUBACK        IFEQ      'Y'
     C                   Z-ADD     WUEDAT        WZAICD
     C                   ENDIF
      *
     C                   TESTB     '3'           UDSTI                    81
      *
     C     *IN81         IFEQ      *ON
     C                   MOVE      'Y'           WZAVRM            1
     C                   ELSE
     C                   MOVE      'N'           WZAVRM
     C                   ENDIF
      *
     C                   Z-ADD     WENDDT        WZEDAT            5 0
     C                   Z-ADD     SDCAR         WZSDCR            5 0
     C                   MOVEL     'P'           WZDIR             1
     C                   MOVEL     UIPFR         WZIPFC            1
     C                   MOVEL     UINPM         WZINPM            1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNTCF -  Calculates interest rate for THEIR non-OIS side    *
      *            using CASH FLOW schedule method.                   *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRNTCF        BEGSR
      *
      **  Define fields for subroutine
      *
     C                   Z-ADD     0             WZAITD           13 0
     C                   Z-ADD     0             WINTD            13 0
      *
     C                   Z-ADD     CFLA          ZINTR
      *
      ** Add Interest Accrued to Control Date (TAITC), Interest
      ** Accrued and Adjusted but not posted (TAIAN) and Accrued
      ** Interest Adjusted and Posted (TAIAP) to give accrued interest
      ** to date.
      *
     C     TAITC         ADD       TAIAN         WZAITD
     C     WZAITD        ADD       TAIAP         WZAITD
     C     WZAITD        ADD(H)    ZINTR         WZAITD
      *
      ** Subtract Interest PAID/RECEIVED to Date (TIPRD) from accrued
      ** interest to give the interest due.
      *
     C     WZAITD        SUB       TIPRD         WINTD
      *
      ** If interest is to be Capitalized (TINPM = C) and today is
      ** the maturity date, add interest PAID/RECEIVED to date to the
      ** total interest due.
      *
     C     TINPM         IFEQ      'C'
     C     BJRDNB        IFEQ      MDAT
     C                   ADD       TIPRD         WINTD
     C                   ELSE
     C                   Z-ADD     *ZERO         WINTD
     C                   ENDIF
     C                   ENDIF
      *
      ** The interest amount field (ROINT) on the report is set to the
      ** amount of interest due for a non-OIS RS deal with interest
      ** payable according to a cash flow schedule (WINTD).
      *
     C                   Z-ADD     WINTD         WTINT
      *
      ** The rate field on the report (RTINR) is set to the effective
      ** interest rate (TEINR) from the file DEALSDG
      *
     C                   Z-ADD     TEINR         P@TINR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNOCF -  Calculates interest rate for OUR non-OIS side      *
      *            using CASH FLOW schedule method.                   *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRNOCF        BEGSR
      *
      **  Define fields for subroutine
      *
     C                   Z-ADD     0             WZAITD           13 0
     C                   Z-ADD     0             WINTD            13 0
      *
     C                   Z-ADD     CFLA          ZINTR
      *
      ** Add Interest Accrued to Control Date (UAITC), Interest
      ** Accrued and Adjusted but not posted (UAIAN) and Accrued
      ** Interest Adjusted and Posted (UAIAP) to give accrued interest
      ** to date.
      *
     C     UAITC         ADD       UAIAN         WZAITD
     C     WZAITD        ADD       UAIAP         WZAITD
     C     WZAITD        ADD(H)    ZINTR         WZAITD
      *
      ** Subtract Interest PAID/RECEIVED to Date (UIPRD) from accrued
      ** interest to give the interest due.
      *
     C     WZAITD        SUB       UIPRD         WINTD
      *
      ** If interest is to be Capitalized (UINPM = C) and today is
      ** the maturity date, add interest PAID/RECEIVED to date to the
      ** total interest due.
      *
     C     UINPM         IFEQ      'C'
     C     BJRDNB        IFEQ      MDAT
     C                   ADD       UIPRD         WINTD
     C                   ELSE
     C                   Z-ADD     *ZERO         WINTD
     C                   ENDIF
     C                   ENDIF
      *
      ** If the deal is tax payable calculate the tax on the interest
      ** due
      *
     C     TAXI          IFEQ      'Y'
     C     WINTD         MULT(H)   BNHKTR        WTAXC
     C     WTAXC         DIV       100           WTAX
     C                   ENDIF
      *
      ** Calculate the interest net of tax (our interest amount)
      *
     C     WINTD         SUB(H)    WTAX          WUINOT
      *
      ** The interest amount field (ROINT) on the report is set to the
      ** amount of interest due for a non-OIS RS deal with interest
      ** payable according to a cash flow schedule (WUINOT.)
      *
     C                   Z-ADD     WUINOT        WOINT
      *
      ** The rate field on the report (RTINR) is set to the effective
      ** interest rate (UEINR) from the file DEALSDG
      *
     C                   Z-ADD     UEINR         P@OINR
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDNCF -  Determines if interest is due today from the Cash  *
      *            Flow Schedule file                                 *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRDNCF        BEGSR
      *
     C                   Z-ADD     BJRDNB        PRDT
      *
      ** Check if any entry on the file for today.
      *
      *
      ** Build Key List IRSCFL.
      *
     C                   MOVE      DLNO          KDEAL
     C                   MOVE      OTIN          KOTIN
     C                   MOVE      PRDT          KPRDT
      *
     C     IRSCFL        CHAIN     DLCFSCPD                           74
      *
     C     *IN74         IFEQ      *ON
     C                   Z-ADD     *ZERO         CFLA
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNINT -  Calculates interest using standard method for a    *
      *            non-OIS side that is settling today                *
      *                                                               *
      *  Called By : SRNOIS                                           *
      *                                                               *
      *  Calls     : GLINTC                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRNINT        BEGSR
      *
      ** OUR side of the deal is not an OIS
      *
     C     UICFR         IFNE      'O'
      *
      ** Set up parameters for call to GLINTC
      *
     C                   MOVE      UEINR         ZIRATE
     C                   MOVE      UICBS         ZICALC
     C                   MOVE      UIACD         ZIBEG
     C                   MOVE      BJRDNB        ZIEND
     C                   MOVE      UPAMT         ZIAMT
     C                   MOVE      'U'           OTIN                                         CIR013
      *
     C                   EXSR      GLINTC
      *
     C                   MOVE      UEINR         P@OINR
      *
     C                   Z-ADD     ZINTR         WOINT
     C     UAITC         ADD       WOINT         WOINT
     C     UAIAN         ADD       WOINT         WOINT
     C     WOINT         SUB       UAIAP         WOINT
     C     WOINT         SUB       UIPRD         WOINT
      *
     C     WTAXR         IFNE      0
     C     TAXI          ANDEQ     'Y'
     C     WOINT         MULT      WTAXR         WRKTAX
     C     WOINT         SUB       WRKTAX        WOINT
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** THEIR side of the deal is not an OIS
      *
     C     TICFR         IFNE      'O'
      *
      ** Set up parameters for call to GLINTC
      *
     C                   MOVE      TEINR         ZIRATE
     C                   MOVE      TICBS         ZICALC
     C                   MOVE      TIACD         ZIBEG
     C                   MOVE      BJRDNB        ZIEND
     C                   MOVE      TPAMT         ZIAMT
     C                   MOVE      'T'           OTIN                                         CIR013
      *
     C                   EXSR      GLINTC
      *
     C                   MOVE      TEINR         P@TINR
      *
     C                   Z-ADD     ZINTR         WTINT
     C     TAITC         ADD       WTINT         WTINT
     C     TAIAN         ADD       WTINT         WTINT
     C     WTINT         SUB       TAIAP         WTINT
     C     WTINT         SUB       TIPRD         WTINT
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNETS -  Calculates the Net Settlement                      *
      *                                                               *
      *  Called By : SRSELR                                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRNETS        BEGSR
      *
      ** Calculate Net Settlement
      *
     C     WOINT         IFGT      WTINT
     C     WOINT         SUB       WTINT         W#NTSL
     C                   MOVE      'P'           W#PYRC
     C                   ELSE
      *
     C     WTINT         IFGT      WOINT
     C     WTINT         SUB       WOINT         W#NTSL
     C                   MOVE      'R'           W#PYRC
     C                   ELSE
     C                   Z-ADD     0             W#NTSL
     C                   MOVE      'P'           W#PYRC
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRREPT -  Report Processing                                  *
      *                                                               *
      *  Called By : SRSELR                                           *
      *                                                               *
      *  Calls     : AOCUSTR0, *PSSR, AOCURRR0, ZSEDIT                *
      *                                                               *
      *****************************************************************
      *
     C     SRREPT        BEGSR
      *
     C                   ADD       1             RCOUNT            4 0
     C                   MOVE      CNUM          W#CNUM           10
      *
      ** Call access program for Customer Report Name
      *
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*MSG    '    PRETN             7
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      W#CNUM        PCNUM            10
     C                   PARM      *BLANKS       PKYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
      *
     C     PRETN         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCUSTPD'    DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVEL     CNUM          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Call access program for Number decimal places of Currency
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      '*MSG    '    PRETN
     C                   PARM      '*KEY    '    POPTN
     C                   PARM      UCUCY         PCCY              3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     PRETN         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   Z-ADD     13            DBASE
     C                   MOVEL     PCCY          DBKEY
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Interest rate
      ** -------------
      ** Perform rounding off of Interest Rate based on the
      ** OIS Interest Rate Decimals on SDCURRPD. Do this only for
      ** each side of the deal which is an OIS.
      *
     C     UICFR         IFEQ      'O'
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  P@OINR        W@OIN0           11 0
     C                   Z-ADD     W@OIN0        W@OINR
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  P@OINR        W@OIN1           11 1
     C                   Z-ADD     W@OIN1        W@OINR
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  P@OINR        W@OIN2           11 2
     C                   Z-ADD     W@OIN2        W@OINR
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  P@OINR        W@OIN3           11 3
     C                   Z-ADD     W@OIN3        W@OINR
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  P@OINR        W@OIN4           11 4
     C                   Z-ADD     W@OIN4        W@OINR
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  P@OINR        W@OIN5           11 5
     C                   Z-ADD     W@OIN5        W@OINR
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  P@OINR        W@OIN6           11 6
     C                   Z-ADD     W@OIN6        W@OINR
     C     A6IRDP        WHENEQ    7
     C                   Z-ADD(H)  P@OINR        W@OIN7           11 7
     C                   Z-ADD     W@OIN7        W@OINR
     C                   ENDSL
     C                   ELSE
     C                   Z-ADD     P@OINR        W@OINR           11 7
     C                   ENDIF
      *
     C     TICFR         IFEQ      'O'
     C                   SELECT
     C     A6IRDP        WHENEQ    0
     C                   Z-ADD(H)  P@TINR        W@TIN0           11 0
     C                   Z-ADD     W@TIN0        W@TINR
     C     A6IRDP        WHENEQ    1
     C                   Z-ADD(H)  P@TINR        W@TIN1           11 1
     C                   Z-ADD     W@TIN1        W@TINR
     C     A6IRDP        WHENEQ    2
     C                   Z-ADD(H)  P@TINR        W@TIN2           11 2
     C                   Z-ADD     W@TIN2        W@TINR
     C     A6IRDP        WHENEQ    3
     C                   Z-ADD(H)  P@TINR        W@TIN3           11 3
     C                   Z-ADD     W@TIN3        W@TINR
     C     A6IRDP        WHENEQ    4
     C                   Z-ADD(H)  P@TINR        W@TIN4           11 4
     C                   Z-ADD     W@TIN4        W@TINR
     C     A6IRDP        WHENEQ    5
     C                   Z-ADD(H)  P@TINR        W@TIN5           11 5
     C                   Z-ADD     W@TIN5        W@TINR
     C     A6IRDP        WHENEQ    6
     C                   Z-ADD(H)  P@TINR        W@TIN6           11 6
     C                   Z-ADD     W@TIN6        W@TINR
     C     A6IRDP        WHENEQ    7
     C                   Z-ADD(H)  P@TINR        W@TIN7           11 7
     C                   Z-ADD     W@TIN7        W@TINR
     C                   ENDSL
     C                   ELSE
     C                   Z-ADD     P@TINR        W@TINR           11 7
     C                   ENDIF
      *
      ** Call ZSEDIT for fields where decimal places depend on deal
      ** currency.  ZSEDIT Inserts sign, commas and a decimal point
      ** into numeric field and blanks out leading zeros.
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      L1PRIN        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        RPRIN
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WTINT         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        RTINT
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      WOINT         ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        ROINT
      *
     C                   MOVE      *BLANKS       ZFLD15
     C                   MOVE      W#NTSL        ZFLD15
     C                   Z-ADD     A6NBDP        ZDECS
     C                   MOVE      'J'           ZECODE
     C                   EXSR      ZSEDIT
     C                   MOVE      ZOUT21        RNTSL
      *
     C                   MOVE      DLNO          PDLNO
      *
     C                   MOVE      DLNO          RDLNO
     C                   MOVE      BBCSSN        RCSSN
     C                   MOVE      UCUCY         RCUCY
     C                   MOVE      W@OINR        ROINR
     C                   MOVE      W@TINR        RTINR
     C                   MOVE      W#PYRC        RPYRC
      *
      ** Check that sufficient lines remain for the Form
      ** write out the Main Headings on a new page.
      *
     C                   Z-ADD     1             WRQDLN
     C     OFLLN1        SUB       PRTLN1        WDIFLN
     C     WDIFLN        IFLE      WRQDLN
     C                   WRITE     PGHEADER
     C                   WRITE     DTHEADER
     C                   ENDIF
      *
     C                   WRITE     DLDETAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRENDP -  Termination Processing                             *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRENDP        BEGSR
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDT -  Audit processing                                   *
      *                                                               *
      *  Called By : Main Processing, *PSSR                           *
      *                                                               *
      *  Calls     : NONE                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRAUDT        BEGSR
      *
      ** Output Report Header and File Controls.
      *
     C                   WRITE     HEADERAU
     C                   WRITE     CONTROL
      *
      ** If there is a DB Error, Output the DB Error Information.
      *
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
     C                   ELSE
      *
      ** Or, if no records read, Output "No Details" message.
      *
     C     RCOUNT        IFEQ      0
      *
     C                   WRITE     NODTLS
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Write Trailer for Audit Report.
      *
     C                   WRITE     AUTRAIL
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFP - RCF Processing for Printer File DL1642P1             *
      *                                                               *
      *  Called By : SRHEAD                                           *
      *                                                               *
      *  Calls     : ZSFILE                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFP        BEGSR
      *
      ** Ensure Report Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUM1        PSNUM             6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ              5
     C                   PARM      *BLANKS       PENTY             3
     C                   PARM                    SFILE1
     C                   PARM                    PSNUM
     C                   PARM      *BLANKS       PSERR             1
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     PSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRCFA - RCF Processing for Audit File DL1642AU               *
      *                                                               *
      *  Called By : *INZSR                                           *
      *                                                               *
      *  Calls     : ZSFILE                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFA        BEGSR
      *
      ** Ensure Audit Spool File recorded by RCF.
      *
     C                   Z-ADD     SFNUMU        PSNUMU            6 0
      *
     C                   CALL      'ZSFILE'
     C                   PARM                    PSEQ
     C                   PARM      *BLANK        PENTY
     C                   PARM                    SFILEU
     C                   PARM                    PSNUMU
     C                   PARM      *BLANK        PSERR
      *
      ** If Error occurs during ZSFILE processing, then return to the
      ** Calling Program.
      *
     C     PSERR         IFEQ      'Y'
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *                                                               *
      *  Called By : Main Processing                                  *
      *                                                               *
      *  Calls     : SRRCFA, AODEALR0, AOBANKR0, *PSSR                *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PSEQ              5
     C                   PARM                    PLEV              1
     C                   PARM                    PENT              3
     C                   PARM                    PCURR             3
      *
      ** Set up copyright parameter.
      *
     C                   MOVEA     CPY@          CPY2@            80
      *
      ** Initialise LDA field.
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C     *LOCK         IN        LDA
     C                   MOVEL     'DL1642'      DBPGM
     C                   Z-ADD     0             DBASE
     C                   MOVE      *BLANKS       DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   OUT       LDA
      *
      ** Initialise all working fields
      *
     C                   Z-ADD     0             K@DLNO            6 0
     C                   MOVE      *BLANKS       K@OTCD            1
     C                   Z-ADD     0             P@TINR           11 7
     C                   Z-ADD     0             P@TINT           13 0
     C                   Z-ADD     0             P@OINR           11 7
     C                   Z-ADD     0             P@OINT           13 0
     C                   Z-ADD     0             WOINT            13 0
     C                   Z-ADD     0             WTINT            13 0
     C                   Z-ADD     0             L1AMNT           13 0
     C                   Z-ADD     0             W#NTSL           13 0
     C                   MOVE      *BLANKS       W#PYRC            1
     C                   Z-ADD     0             WTAXR             5 4
     C                   Z-ADD     0             WRKTAX           15 0
     C                   Z-ADD     0             WRQDLN            3 0
     C                   Z-ADD     0             WDIFLN            3 0
      *
      ** RCF Processing for Audit File
      *
     C                   EXSR      SRRCFA
      *
      ** Key List used to position in OIS Settlement Control File
      ** PF/DLOISSPD.
      *
     C     KYOISS        KLIST
     C                   KFLD                    KCURR             3
     C                   KFLD                    KBRCA             3
     C                   KFLD                    KDLNO             6 0
      *
     C     DLOISS        KLIST
     C                   KFLD                    KCURR
     C                   KFLD                    KBRCA
      *
      ** Key list used for positioning to the Date Schedule
      ** file DLDTSCPD
      *
     C     IRSDTL        KLIST
     C                   KFLD                    KDEAL             6 0
     C                   KFLD                    KOTIN             1
     C                   KFLD                    KRCIP             1
     C                   KFLD                    KPRDT             5 0
      *
      ** Key list used for reading the Date Schedule
      ** file DLDTSCPD
      *
     C     IRSDTP        KLIST
     C                   KFLD                    KDEAL
     C                   KFLD                    KOTIN
     C                   KFLD                    KRCIP
      *
      ** Set up key lists for Deals OIS Details file - DLDOISPD.
      *
     C     OISKY2        KLIST
     C                   KFLD                    K@DLNO            6 0
     C                   KFLD                    K@OTCD            1
      *
      ** Key list used to chain to the Cash Flow schedule file DLCFSCPD
      *
     C     IRSCFL        KLIST
     C                   KFLD                    KDEAL             6 0
     C                   KFLD                    KOTIN             1
     C                   KFLD                    KPRDT             5 0
      *
      ** Call access program to obtain Hong Kong Tax Rate
      *
     C**********           CALL 'AODEALR0'                                                    CGL029
     C                   CALL      'AODEALR1'                                                 CGL029
     C                   PARM      '*MSG    '    PRTNC             7
     C                   PARM      '*FIRST  '    POPTN             7
     C********** SDDEAL    PARM SDDEAL    DSFDY                                               CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
     C     PRTNC         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDDEALPD'    DBFILE
     C                   MOVEL     POPTN         DBKEY
     C                   Z-ADD     1             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Divide the HK Tax rate by 100 to give working Tax Rate field
      *
     C     BNHKTR        DIV       100           WTAXR             5 4
      *
      ** Call access program to obtain Bank Name
      ** Database error processing carried out internally
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*BLANKS '    PRTNC
     C                   PARM      '*FIRST  '    POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Data base error in file (file)
      *
     C     PRTNC         IFNE      *BLANK
     C     *LOCK         IN        LDA
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '*FIRST'      DBKEY
     C                   Z-ADD     2             DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR details file to determine if CIR004
      ** is switched on.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       PRTRN             7
     C                   PARM      '*VERIFY '    POPTN
     C                   PARM      'CIR004'      PSARD             6
      *
     C     PRTRN         IFNE      *BLANKS
     C     PRTRN         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVEL     'CIR004'      DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     PRTRN         IFEQ      *BLANKS
     C                   MOVE      'Y'           CIR004            1
     C                   ELSE
     C                   MOVE      'N'           CIR004
     C                   ENDIF
      *****************************************************************            MD035545 MD047993
      ***Call*access*program*for*General*Ledger*details.***************            MD035545 MD047993
      *****************************************************************            MD035545 MD047993
     C**********         CALL      'AOGELRR1'                                      MD035545 MD047993
     C**********         PARM      '*MSG'        @RTCD             7               MD035545 MD047993
     C**********         PARM      '*FIRST '     @OPTN             7               MD035545 MD047993
     C*****SDGELR        PARM      SDGELR        DSSDY                             MD035545 MD047993
      *                                                                                     MD035545
     C*****@RTCD         IFNE      *BLANK                                          MD035545 MD047993
     C**********         MOVEL     'SDGELRPD'    W0FILE                            MD035545 MD047993
     C**********         MOVEL     '062'         W0ERNB                            MD035545 MD047993
     C**********         MOVEL     @OPTN         W0KEY                             MD035545 MD047993
     C**********         EXSR      SRERR                                           MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD047993
      **********                                                                   MD035545 MD051554
      ***Retrieve*system*value*setting****************                             MD035545 MD051554
      **********                                                                   MD035545 MD051554
     C**********         MOVEL     WPARML        P@OP01                            MD035545 MD051554
     C**********         CALL      'AOSVALR0'                                      MD035545 MD051554
     C**********         PARM      *BLANKS       W0RTCD            7               MD035545 MD051554
     C**********         PARM                    P@OP01           20               MD035545 MD051554
     C**********         PARM                    P@VL01          200               MD035545 MD051554
     C**********         PARM                    P@OP02           20               MD035545 MD051554
     C**********         PARM                    P@VL02          200               MD035545 MD051554
     C**********         PARM                    P@OP03           20               MD035545 MD051554
     C**********         PARM                    P@VL03          200               MD035545 MD051554
     C**********         PARM                    P@OP04           20               MD035545 MD051554
     C**********         PARM                    P@VL04          200               MD035545 MD051554
     C**********         PARM                    P@OP05           20               MD035545 MD051554
     C**********         PARM                    P@VL05          200               MD035545 MD051554
     C**********         PARM                    P@OP06           20               MD035545 MD051554
     C**********         PARM                    P@VL06          200               MD035545 MD051554
     C**********         PARM                    P@OP07           20               MD035545 MD051554
     C**********         PARM                    P@VL07          200               MD035545 MD051554
     C**********         PARM                    P@OP08           20               MD035545 MD051554
     C**********         PARM                    P@VL08          200               MD035545 MD051554
     C**********         PARM                    P@OP09           20               MD035545 MD051554
     C**********         PARM                    P@VL09          200               MD035545 MD051554
     C**********         PARM                    P@OP10           20               MD035545 MD051554
     C**********         PARM                    P@VL10          200               MD035545 MD051554
      **********                                                                   MD035545 MD051554
      ***If*system value is not found then default value to 'N'                    MD035545 MD051554
      **********                                                                   MD035545 MD051554
     C*****W0RTCD        IFNE      '       '                                       MD035545 MD051554
     C**********         MOVE      'N'           WCALC6                            MD035545 MD051554
     C**********         ELSE                                                      MD035545 MD051554
     C**********         MOVEL     P@VL01        WCALC6                            MD035545 MD051554
     C*****WCALC6        IFEQ      'Y'                                             MD035545 MD047993
     C*****BKALDI        ANDEQ     'Y'                                             MD035545 MD047993
     C**********         MOVE      'Y'           WCALC6                            MD035545 MD047993
     C**********         ELSE                                                      MD035545 MD047993
     C**********         MOVE      'N'           WCALC6                            MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD047993
     C**********         ENDIF                                                     MD035545 MD051554
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called By : *INZSR, SRSELR, SRHEAD, SRTBRT, SROBRT, SRREPT   *
      *                                                               *
      *  Calls     : SRAUDT                                           *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C     WRUN          IFEQ      *BLANK
     C                   MOVE      'Y'           WRUN              1
     C                   MOVE      *ON           *INU7
     C                   MOVE      *ON           *INU8
     C                   MOVE      *ON           *INLR
     C                   DUMP
     C                   EXSR      SRAUDT
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      ********************************************************************
      /EJECT
     C*COPY ZSRSRC,ZSEDITZ3                                                                   220859
     C/COPY ZSRSRC,ZSEDITZ3LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,GLINTCZ1                                                                   220859
     C/COPY ZSRSRC,GLINTCZ1LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZINTDYZ2                                                                   220859
     C/COPY ZSRSRC,ZINTDYZ2LE                                                                 220859
      /EJECT
     C*COPY ZSRSRC,ZDATE9Z3                                                                   220859
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 220859
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
      /EJECT
     C*COPY ZSRSRC,ZDAT10Z2                                                                   220859
     C/COPY ZSRSRC,ZDAT10Z2LE                                                                 220859
      /EJECT                                                                                  204923
     C*COPY ZSRSRC,ZBKDT                                                               204923 220859
     C/COPY ZSRSRC,ZBKDT_ILE                                                                  220859
      /EJECT                                                                                  204923
     C*COPY ZSRSRC,ZACCH                                                               204923 220859
     C/COPY ZSRSRC,ZACCHLE                                                                    220859
      /EJECT                                                                                  204923
**  CPY@
(c) Finastra International Limited 2001
** @YD  USED BY SR. ZDATE9 - YEARS, IN DAYS, CUMULATIVE IN 4 YEAR SPAN
00366007310109601461
** @MD  USED BY SR. ZDATE9 - MONTHS IN DAYS CUMULATIVE THROUGH YEAR
00000000310005900090001200015100181002120024300273003040033400365
