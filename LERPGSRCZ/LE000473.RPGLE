     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('MIDAS LE Past Due Call Loan creation/update')          *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE000473 - Past Due Call Loan creation/update                *
      *                                                               *
      *  Function:  This module will be called by the new loan/fees   *
      *             repayment functions                               *
      *                                                               *
      *  Called By: LEC000473                                         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD049745A          Date 16Mar18               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD049078           Date 12Jan18               *
      *                 MD046080           Date 17Sep17               *    
      *                 MD035433           Date 02Sep15               *
      *                 MD033895           Date 15Apr15               *
      *                 MD031851           Date 25Jan15               *
      *                 MD031225           Date 10Dec14               *
      *                 MD027206           Date 19Aug14               *
      *                 MD025112           Date 11May14               *
      *                 MD023442           Date 05Mayl4               *
      *                 MD023596           Date 30Aprl4               *
      *                 MD023203           Date 24Aprl4               *
      *                 MD022807I          Date 24Aprl4               *
      *                 MD023162           Date 23Aprl4               *
      *                 MD022807H          Date 22Aprl4               *
      *                 MD022807E          Date 16Oct13               *
      *                 MD022807C          Date 15Oct13               *
      *                 MD022807B          Date 14Oct13               *
      *                 MD022807A          Date 11Oct13               *
      *                 MD022807           Date 10Oct13               *
      *                 MD022640           Date 01Oct13               *
      *                 MD022465           Date 24Sep13               *
      *                 MD021423E          Date 12Sep13               *
      *                 MD021423D          Date 09Sep13               *
      *                 MD021423B          Date 04Sep13               *
      *                 MD021423A          Date 03Sep13               *
      *                 MD021423 *REWRITE  Date 21Aug13               *
      *                 MD020954           Date 02Aug13               *
      *                 MD021476           Date 30Jul13               *
      *                 MD021018           Date 27Jun13               *
      *                 MD020966           Date 20Jun13               *
      *                 MD020343           Date 18May13               *
      *                 MD020534           Date 23May13               *
      *                 MD020209           Date 14May13               *
      *                 AR782473           Date 14May13               *
      *                 MD020095           Date 02May13               *
      *                 AR827807           Date 24Apr13               *
      *                 MD019881           Date 22Apr13               *
      *                 AR1095331          Date 07Apr13               *
      *                 MD019829           Date 04Apr13               *
      *                 AR1097132          Date 23Mar13               *
      *                 AR1095652          Date 12Mar13               *
      *                 AR1093780          Date 05Mar13               *
      *                 AR1094241          Date 03Mar13               *
      *                 AR1091136          Date 26Feb13               *
      *                 AR1077063          Date 10Feb13               *
      *                 AR1076968A         Date 07Feb13               *
      *                 AR1085742          Date 06Jan13               *
      *                 AR1086749          Date 12Feb13               *
      *                 AR796443           Date 09Feb13               *
      *                 AR1080660          Date 26Jan13               *
      *                 AR1075853          Date 08Jan13               *
      *                 AR1073390          Date 30Dec12               *
      *                 AR1073095          Date 27Dec12               *
      *                 AR1061940          Date 28Nov12               *
      *                 AR1055539          Date 12Nov12               *
      *                 AR798695           Date 09Nov12               *
      *                 AR1022006          Date 01Aug12               *
      *                 AR1021983          Date 01Aug12               *
      *                 AR706513           Date 05Jul12               *
      *                 CLE148             Date 05Dec11               *
      *                 AR719589           Date 01Aug12               *
      *                 AR705750           Date 01Aug12               *
      *                 AR571209           Date 01Aug12               *
      *                 AR551942           Date 01Aug12               *
      *                 AR549587           Date 01Aug12               *
      *                 AR467421           Date 01Aug12               *
      *                 AR467031           Date 01Aug12               *
      *                 AR375982           Date 01Aug12               *
      *                 AR323561           Date 01Aug12               *
      *                 AR322561           Date 01Aug12               *
      *                 AR322571           Date 01Aug12               *
      *                 AR214141A          Date 01Aug12               *
      *                 263840             Date 01Aug12               *
      *                 263628             Date 01Aug12               *
      *                 263228             Date 01Aug12               *
      *                 263074             Date 01Aug12               *
      *                 CLE134   *CREATE   Date 01Aug12               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD049745A - Corruption of Original currency of Loans and     *
      *              PDCLs incorrect postings                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD049078 - Wrong postings of MR and RE of PDCL loan          *
      *  MD046080 - Gap between CLE031 (Settlement to different       *
      *             currency) and CLE134 (PDCL processing)            *     
      *  MD035433 - System generated new PDCL instead of using old    *
      *             one. Evaluate WRECI equals to 'D' for AYSIIN = 'Y'*
      *             to correctly retrieve record of PDCL details.     *
      *  MD033895 - Password retrieval issue on LEC000456 during COB  *
      *  MD031851 - Unable to generate PDCL Y if the PDCL has no base *
      *             rate code.                                        *
      *  MD031225 - Unable to generate loan as fixed rate and spread  *
      *             has same value. Make sure FXRT will be populated  *
      *             from RTSP only when BRTT and BASR equal to zero.  *
      *           - Set the initial start date equal to value date.   *
      *  MD027206 - LEC000456 00001 failed in BB (88-96 patch)        *
      *  MD025112 - Incorrect LASQ field of PDCL loan fees in         *
      *             CLOANCL file                                      *
      *  MD023442 - ORBR field is blank for Facility Fee PDCLs        *
      *  MD023596 - Enhance MD022807A. Don't ignore HISTSHQ so that   *
      *             BC and SC will be counted.                        *
      *  MD023203 - Update LEPDCL data area                           *
      *  MD022807I - Wrong PDCL reference in LEMQLGPD for CLIP        *
      *  MD023162 - Generation of event date is not correct when      *
      *             the event date falls on a holiday                 *
      *  MD022807H - Value date of PDCL and PI should be defaulted    *
      *              from the value date of the transaction           *
      *  MD022807E - Record went to repair queue due to deal/start    *
      *              date error                                       *
      *            - Use VDAT instead of RUNDAT to chain LOAMS and    *
      *              HISTSHP to get the latest sequnce number.        *
      *            - Incorrect PDCL Fee reference for PI event        *
      *  MD022807C - Default pay settlement of the PDCL's Principal   *
      *              Increase into '00'                               *
      *  MD022807B - Use *IN79 instead of *IN99.                      *
      *            - Default loan number.                             *
      *  MD022807A - History records must also be check for next      *
      *              sequence number.                                 *
      *  MD022807 -  Settlement details of LOAM should be coming      *
      *              from PDCL loans and not from OL                  *
      *  MD022640 -  ROBN ROCN RIBN RIBA must be blank if RSTM is not *
      *              01 07 or 08                                      *
      *           -  RELI amd BMDI not setup correctly                *
      *           -  NAR1 incorrect for FeeLoan                       *
      *           -  RIBN incorrect for FeeLoan                       *
      *           -  RIBA incorrect for FeeLoan                       *
      *           -  ROBN incorrect for FeeLoan                       *
      *           -  ROCN incorrect for FeeLoan                       *
      *           -  POBN POCN PIBN PIBA must be blank if PSTM is not *
      *              01 07 or 08                                      *
      *           - ORBR  not populated for PDCL created for fee      *
      *           - CLE134: Wrong book in ZZ PDCL. Populate fee loan  *
      *              book code with book code of loan from PF/CLOANCL.*
      *  MD022465 - Matured loans should not generate SC/BC events    *
      *  MD021423E - Deal date should be the deal date of the OL      *
      *              Pay instruction should be defaulted from receipt *
      *              instruction of the OL                            *
      *  MD021423D - Abnormally long run of PDCL/MAPY processing      *
      *              Error in LASQ field                              *
      *  MD021423B - Abnormally long run of PDCL/MAPY processing      *
      *              Need to pass 'AUTH' field block                  *
      *  MD021423A- Abnormally long run of PDCL/MAPY processing       *
      *             components (Reopen)                               *
      *  MD021423 - Abnormally long run of PDCL/MAPY processing       *
      *             components                                        *
      *  MD020954 - Missing projection for new PDCL. Update on CLOANE *
      *             must be done in LECLIPUPD.                        *
      *  MD021476 - PDCL was started from wrong account due to        *
      *             incorrect account key generated                   *
      *  MD021018 - PDCL Loan amendments went to repair queue due     *
      *             due to same sequence number                       *
      *  MD020966 - Payments for Past due loans are posted twice      *
      *  MD020343 - Erroneous original loan reference in report       *
      *  MD020534 - System did not generate PDCL for the unpaid due   *
      *             balance of interest after COB                     *
      *  MD020209 - LEPDUEPD with discrepancy in number of records.   *
      *             Duplicate header (RECI = 'p') generated in        *
      *             LEPDUEPD.                                         *
      *  AR782473 - Wrong value date of PDCL creation. Ensure that    *
      *             the actual value date of repayment is used for    *
      *             new PDCL.                                         *
      *             Applied for MD020209.                             *
      *  MD020095  - LEC000138 Component failed                       *
      *  AR827807 - Loan Fee PDCL does not default sequence number    *
      *             from Facility. SFDC00572444 (Child: AR827808)     *
      *  MD019881 - Two PDCLs are generated for PDCL with Capitalised *
      *             Interest set to Y                                 *
      *  AR1095331 - BFTC Security Issues                             *
      *  MD019829  - LEC000138 and LEC000456 cannot run               *
      *              simultaneously due to locking issue              *
      *  AR1097132 - LEC000456 00001 failed due to record locks       *
      *  AR1095652 - Amount is incorrect - PDCL transaction sent      *
      *              to repair queue                                  *
      *  AR1093780 - LOAM-DDPONX - Invalid settlement branch entered  *
      *  AR1094241 - LOAM-DDCURR - Currency entered must be the       *
      *              same as the Loan Currency                        *
      *  AR1091136 - After drop2 MQ processing now requires password  *
      *              as part of the message authentication            *
      *  AR1077063 - Encountered FOOB in LEC06A seq 04001             *
      *  AR1076968A - System did not generate PDCL fees for unpaid    *
      *               portion of Fee due                              *
      *  AR1085742 - Recovery handling when PDP components loop due   *
      *              to database connection issues                    *
      *  AR1086749 - LEC000131 encountered database error during COB  *
      *              DBERR in SDCURRPD.                               *
      *  AR796443 - Database error 007 occurred when checking for     *
      *             newly matured fees. Use LEFEEDL1 when checking    *
      *             fees instead of LEFEEDL0. (Child: AR796444)       *
      *  AR1080660 - Erroneous generated result with PDCL details     *
      *  AR1075853 - APCTRANR does not allow transactions from being  *
      *              processed during COB                             *
      *  AR1073390 - Amount being sent to Java for PDCL creation is   *
      *              invalid for when there are partial payment       *
      *  AR1073095 - LELWNEPD is being updated by LEC000131 causing   *
      *              a decimal data error                             *
      *  AR1061940 - LEC06A component failed during clean COB         *
      *              (Recompile)                                      *
      *  AR1055539 - Various errors encountered in COB during         *
      *              Link Test                                        *
      *  AR798695 - Performance issue on LEC0456.                     *
      *             - remove setting ON of *INLR upon return          *
      *             - externalise *entry and keyfields from *INZSR    *
      *             (Child: AR798696)                                 *
      *  AR1022006 - COB Performance Optimisation                     *
      *  AR1021983 - Option C - Technical Enhancements Stated in POC  *
      *  AR706513 - Branch not populated for PDCL created for fee for *
      *             settlement 05. Corrected mapping of fields.       *
      *             Added fix for base rate change indicator.         *
      *             (Child: AR719825)                                 *
      *  CLE148 - Alpha Loan Reference                                *
      *  AR719589 - Wrong base rate change indicator for PDCL (fee).  *
      *             Fix is to use the correct variable AUBSRI from    *
      *             SDFEEPD. (Child: AR719590)                        *
      *  AR705750 - Use FCXR and FMDI of origin loan for PDCL for     *
      *             loan. (Child: AR705927)                           *
      *  AR571209 - Drawn amount on the Facility History plus         *
      *             calculated fee                                    *
      *           - When separate indicator = 'N' and Capitalized     *
      *             Indicator = 'N', then ignore the past due interest*
      *             (Child: AR571217)                                 *
      *  AR551942 - Impossible to reactivate Default Penalty rate     *
      *              after deletion                                   *
      *           - Recompiled after changes to LEPRATL1.             *
      *             (Child: AR551943)                                 *
      *  AR549587 - CLE134:An error during Default Penalty Rate       *
      *             changing.                                         *
      *           - Amend AR467031 so blanks on LEPRATPD are used     *
      *             after all for Base Rate/Spread fields.            *
      *             (Child: AR549657)                                 *
      *  AR467421 - Base Rate Change Error                            *
      *             (Unexpected storno for PDCL for Interest)         *
      *           - SPIN must not be blank even if RTSP & BRTE are 0. *
      *             (Child: AR467422)                                 *
      *  AR467031 - Wrong Outstanding Interest amount for PDCL        *
      *           - after Default Penalty Rate was changed.           *
      *           - Default of field ICBS must depend on Loan type    *
      *             (Child: AR467032)                                 *
      *  AR375982 - Unexpected amount on the Past Due suspense account*
      *           - Fees PDCL has wrong Principal                     *
      *             (Child: AR375983)                                 *
      *  AR323561 - Wrong Loan Number Range for PDCL                  *
      *           - Use Interest PDCL Loan Type/Sub Type to retrieve  *
      *             Interest PDCL Loan Number Range.                  *
      *             (Child: AR323562)                                 *
      *  AR322561 - Back valued Repayment schedule event              *
      *             for PDCL booking.                                 *
      *           - Use W@EDATYP for Value Date of PI on LOAMSDK.     *
      *             (Child: AR322562)                                 *
      *  AR322571 - Wrong PDCL Account Sequence Number                *
      *           - Take LASQ from Original Loan for PDCL.            *
      *             (Child: AR322572)                                 *
      *  AR214141A - LE0457 was crashing in the Past due test system  *
      *           - Amend BIC array to increase size to 999           *
      *            (Child: AR214147)                                  *
      *  263840 - Wrong outstanding/available amounts on enquiries.   *
      *         - Correct update of facility utilisation for PDCLs.   *
      *  263628 - LE0473 issues                                       *
      *         - Incorrect returned value for Principal and Interest *
      *  263228 - No accrued interest postings for PDCL               *
      *         - Incorrect interest rate value                       *
      *  263074 - Original Loans posting errors                       *
      *         - Wrong Posting generated when                        *
      *           there is partial payment                            *
      *  CLE134 - Past Due Call Loan Processing                       *
      *         - CC03: Generation of Past Due Call Loans for Fees    *
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
      *
      ** LE Facility Amendements
     FLEFCAML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(LEFCAMPF:LEFCAMD3)
      *
      ** LE Loans File K
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(C_)
      *
      ** LE Loans File C
     FCLOANC    IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCLF)
     F                                     IGNORE(CLOANZ1F)
     F                                     PREFIX(K_)
      *
      ** Penalties file
     FLEPRATL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** Fees File Format
     FLEFEEDL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(E_)
      *
      ** Retail Account
     FACCNTL1   IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(A_)
      *
      ** Midas PM Portfolio Defns by Front Office ID
     FPMPORTL1  IF   E           K DISK    INFSR(*PSSR)
      *
      ** SD Branch Codes by Customer Number
     FSDBRCHL5  IF   E           K DISK
      *
      ** PDCL Loan Link file
     FLEPDUEL7  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     FLEPDUELA  IF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(LEPDUED0:LEPDUED2)
     F                                     PREFIX(P2_)
     FCLOANLE   IF   E           K DISK    RENAME(CLOANCLF:CLOANLEF)
     F                                     PREFIX(LE_)
     F***LEMQLGL3  IF   E           K DISK    RENAME(LEMQLGPF:LEMQLGPB)                     MD022465
     F**********                           PREFIX(LB_)                                      MD022465
     F***LEMQLGL7  IF   E           K DISK    RENAME(LEMQLGPF:LEMQLGP7)                     MD022465
     F**********                           PREFIX(L7_)                                      MD022465
     FLEMQLGLC  IF   E           K DISK    RENAME(LEMQLGPF:LEMQLGP7)                        MD022465
     F                                     PREFIX(LB_)                                      MD022465
      *                                                                                     MD022465
      ** Midas SD Currency Codes file                                                       MD022465
     FSDCURRL1  IF   E           K DISK                                                     MD022465
      *
      ** PDCL Loan Link file
     FCLOANLF   IF   E           K DISK    RENAME(CLOANCLF:CLOANLFF)
     F                                     PREFIX(LF_)
     FHISTSL0   IF   E           K DISK    PREFIX(HS_)                                     MD022807A
     F                                     IGNORE(HISTSHMF)                                MD022807A
     F**********                           IGNORE(HISTSHQF)                       MD022807A MD023596
      *
      ** PDCL Fee Link file
     FLEPDUFL7  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Loan Amendments for Updating
     FLOAMS     UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     PREFIX(LA_)
      *
      ** Loan Amendments for Updating
     FLELOMKL3  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     RENAME(LOAMSDHF:LOMKSDHF)
     F                                     RENAME(LOAMSDKF:LOMKSDKF)
     F                                     RENAME(LOAMSZ1F:LOMKSZ1F)
     F                                     PREFIX(LA_)
      *
      ** Customer Lending Facility file
     FFCLTY     UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
     F                                     IGNORE(FCLTYHHF)
     F                                     IGNORE(FCLTYZZF)
     F                                     PREFIX(M_)
      *
      ** PDP Transaction Log File sent to MQ
     FLEMQLGL0  UF A E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
 
      *
      ** Temporary Loan Amendments File
     FLELOANPI  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      ** True       logical = *ON (for indcator processing)
      ** False      logical = *OFF (for indcator processing)
      ** DBErrCtl   10A = 'DBERRCTL' (the name of the database error
      ** handler)
      ** and the following variables:
      ** RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error &
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** Arrays and Data Structures
     D @BIC            S              6    DIM(999)
 
      ** For CCY Conversion
     D POWR            S              7  3 DIM(7) CTDATA PERRCD(1)
 
      ** Months Array
     D MONAR           S             10A   DIM(12) CTDATA PERRCD(1)
 
     D                 DS
     D  WPRME                  1     12
     D  WLPFI                  1      1
     D  WPTFC                  2      7
     D  WPTFT                  8     10  0
     D  WPTFN                 11     12  0
 
      ** Dummy Timestamp
     D TimeStmpDS      DS
     D  RetYear                1      4A   INZ('0001')
     D                         5      5A   INZ('-')
     D  RetMonth               6      7A   INZ('01')
     D                         8      8A   INZ('-')
     D  RetDay                 9     10A   INZ('01')
     D                        11     11A   INZ('-')
     D  RetHour               12     13A   INZ('00')
     D                        14     14A   INZ('.')
     D  RetMin                15     16A   INZ('00')
     D                        17     17A   INZ('.')
     D  RetSec                18     19A   INZ('00')
     D                        20     20A   INZ('.')
     D  RetMilli              21     23A   INZ('000')
     D  RetMicro              24     26A   INZ('000')
 
      ** Data structure for database error message
     D                 DS
     D  WFCUS                         6
     D  WFTYP                         3  0
     D  WFSEQ                         2  0
     D  WDBKEY                       11
 
     D DateDS          DS             6
     D   DatDD                 1      2A
     D   DatMM                 3      4S 0
     D   DatYY                 5      6A
 
      ** Working DS with Amounts
     D                 DS
     D  PRAMR                  1     13  0
     D  INTAR                 14     26  0
     D  PNAMR                 27     39  0
     D  TAMTR                 40     52  0
     D  WTXAR                 53     65  0
     D  SAMT                   1     65
 
      ** Loan Amendment Current Amount in numeric
      ** (on Valid format LOAMSDKF)
     D  OPRAM                 66     78  0
     D  OINTA                 79     91  0
     D  OPNAM                 92    104  0
     D  OTAMT                105    117  0
     D  OWTXA                118    130  0
     D  OAMT                  66    130
 
      ** Input Amount in numeric  (on Valid format LEVMAPY)
      ** Data structure of rundates
     D                 DS
     D  M_RUN0                 1      3P 0
     D  M_RUN1                 4      6P 0
     D  M_RUN2                 7      9P 0
     D  M_RUN3                10     12P 0
     D  M_RUN4                13     15P 0
     D  M_RUN5                16     18P 0
     D  M_RUN6                19     21P 0
     D  M_RUN7                22     24P 0
     D  M_RUN8                25     27P 0
     D  M_RUN9                28     30P 0
     D  RUNS                   1     30P 0
 
      ** Fclty dates
     D                                     DIM(10) ASCEND
 
      ** Data structure of drawn amounts
     D                 DS
     D  M_OAM1                 1      7P 0
     D  M_OAM2                 8     14P 0
     D  M_OAM3                15     21P 0
     D  M_OAM4                22     28P 0
     D  M_OAM5                29     35P 0
     D  M_OAM6                36     42P 0
     D  M_OAM7                43     49P 0
     D  M_OAM8                50     56P 0
     D  M_OAM9                57     63P 0
     D  M_OA10                64     70P 0
     D  OAM                    1     70P 0
 
      ** Fclty amounts
     D                                     DIM(10)
 
      ** Input parameters on call to AOPLCSR1
     D I@PARM          DS           256
     D  I#PORS                 1      1
     D  I#R997                 2      5
     D  I#CUST                 6     15
     D  I#BRCA                16     18
     D  I#BOOK                19     20
     D  I#PTFR                21     24
     D  I#CPGM                25     34
 
      ** Output parameters on call to AOPLCSR1
     D O@PARM          DS           256
     D  O#BOOK                 1      2
     D  O#PTFR                 3      6
     D  O#BICN                 7     12
     D  O#CRNM                13     22
     D  O#ACOF                23     24
 
      ** Data structure for Nostro Details
     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
     D QQACCD2       E                     EXTFLD(QQACCD)
 
      ** Data structure for Facility ICD Details
     D SDLENO        E DS                  EXTNAME(SDLENOPD)
 
      ** Data structure for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** Data structure for loan ICD details
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)
 
      ** Data structure for loan ICD details
     D SDLOAN1       E DS                  EXTNAME(SDLOANPD)
     D                                     PREFIX(@)
      ** Data structure for loan ICD details
     D SDLOAN2       E DS                  EXTNAME(SDLOANPD)
     D                                     PREFIX(@2)
      ** Data structure for Branch details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for fees ICD details
     D SDFEE         E DS                  EXTNAME(SDFEEPD )
 
      ** Data structure for AO objects
     D DSSDY         E DS                  EXTNAME(DSSDY   )
 
      ** Short data structure for access objects
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** DS for calculating PC reference
     D LEALLO        E DS                  EXTNAME(LEALLO  )
 
      ** Data structure for Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
 
      ** Portfolio ICD
     D SDPORT        E DS                  EXTNAME(SDPORTPD)
 
      ** Data structure for Facility ICD
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
 
      ** Data structure for Customer Data
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D QQDFAC2       E                     EXTFLD(QQDFAC)
 
      ** Error indicators
     D OKTrPDCL      E DS                  EXTNAME(LEEPDCLPD)
 
      ** Data structure for Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Data structure for General Ledger Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** Data structure for Lending ICD
     D SDCLND        E DS                  EXTNAME(SDCLNDPD)
 
      ** Portfolio management customer details
     D SDPLCS        E DS                  EXTNAME(SDPLCSPD)
 
      ** Current transaction record in file format Loan
     D PDCLFilFmtLoanE DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(C_)
      ** Current transaction record in file format Loan for loan fee
     D PDCLFilFmtLF  E DS                  EXTNAME(CLOANCL)
     D                                     PREFIX(LF_)
 
      ** Current transaction record in file format Loan 2
     D PDCLFilFmtLoaKE DS                  EXTNAME(CLOANCK)
     D                                     PREFIX(K_)
 
      ** Current transaction record in file format Fee
     D PDCLFilFmtFee E DS                  EXTNAME(LEFEED)
     D                                     PREFIX(E_)
 
      ** Current transaction record in file format Facility
     D PDCLFilFmtFctyE DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(M_)
 
      ** Externally desc'd DS for valid loan Details CL
     D LEVCliL       E DS                  EXTNAME(LEVCLILPD)
     D                                     PREFIX(L_)
 
      ** Externally desc'd DS for valid loan Details CL
     D LEVCliK       E DS                  EXTNAME(LEVCLIKPD)
     D                                     PREFIX(R_)
 
     D LEPDCL        E DS                  EXTNAME(LEPDCL)
 
     D                 DS
     D PGlobal                 1      2
     D PZonal                 18     19
     D PWipQueue               1     48
 
     D                 DS
     D  WPGM                          8
     D  WBJRDNB                       5
     D**WPDCLTS*                      6S 0                                                  MD023203
     D**WPDCLSEQ               1     19                                                     MD023203
     D  WPDCLTS                       7S 0                                                  MD023203
     D  WPDCLSEQ               1     20                                                     MD023203
 
     D WDSCURTIME1     DS             8
     D  CURHH1                 1      2A
     D  CURMM1                 4      5A
     D  CURSS1                 7      8A
     D WDSCURTIME2     DS             6
     D  CURHH2                 1      2A
     D  CURMM2                 3      4A
     D  CURSS2                 5      6A
      ** Declared variables
 
      ** Work variable used in *PSSR
     D@RUN             S              1
 
      ** *ENTRY Parameters
     DWRETCD           S              7
     DW@TYPE           S              1
     DW@LOAN           S              6
     DW@FSEQ           S              2  0
     DW@FCOD           S              2  0
     DW@FACL           S              5  0
     DW@FBRCP          S              3
     DW@CNU2           S              6
     DW@EDATYP         S              5  0
     DW@PDAMT          S             15  0
     DW@INT            S             15  0
     DW@AV             S             15  0
     DW@ORIGP          S             15  0
     DW@ORIGI          S             15  0
     DW@LASN           S              3  0
     DW@AVDAT          S              5  0
     DW@DCLTYP         S              1
     DW@OPDAM          S             15  0
     DW@OPDINT         S             15  0
     DWYPLNR           S              6
     DWPGNM            S             10
     DBlockCredit      S              1                                                    MD021423E
     DLoamType         S              2    INZ(*BLANKS)                                    MD021423E
 
      ** Other variables
     DPLoanType        S              2
     DPLSubType        S              2
     DPLClass          S              4
     DWRECI            S              1    INZ('D')
     DWINT             S             15  0
     DWPDAMT           S             15  0
     DWCPAM            S             15  0
     DWAV              S             15  0
     DWPIIN            S              1
     DCLE005           S              1
     DCLE009           S              1
     DCLE014           S              1
     DCLE023           S              1
     DCLE025           S              1
     DCLE031           S              1                                                     MD046080
     DWSCCY            S              3A                                                   MD049745A
     DWSIND            S              1A                                                   MD049745A
     DWSRATE           S             13P 8                                                 MD049745A
     DWKLNR            S              6
     DWKVDT            S              5  0
     DWKLSN            S              3  0
     DWPLON            S              6
     DWSDAT            S              5  0
     D@FACT            S              3
     DWIUSR            S             10    INZ('LE000473')
     DAPFOTRANID       S             10
     DDDFECU           S              6
     DDDFFAC           S              5  0
     DDDFLNO           S              6  0
     DDDFSEQ           S              2  0
     DDDORLN           S              6  0
     DIDX              S              3  0
     DAPRESPMODE       S              1
     DMODEOFOP         S              6
     DWACTN            S              1
     DWMODE            S              1
     D@PRANG           S              2
     DWLTYP            S              2
     DWSUTP            S              2
     DWCLAS            S              4
     DWRCDT1           S              1
     D@FECD            S              2
     DWLASN            S              3  0
     DWTIMES           S              1  0 INZ(0)
     DWLSEQ            S                   LIKE(L_CLLASQ)
 
     DP2_PDCLF         S              1
     D@@RTCD           S              7
     DPPTIN            S              1
     DPGNTF            S              1
     DPTDT1            S             35
     DPTDT2            S             35
     DPTDT3            S             35
     DPTREF            S             15
     DW#SEQ            S              4  0
     DReservId         S             10
     DCallModCode      S              3
     DWRK_139          S             13  9
     D@KEY3            S             10
     D@KYST            S              7
     D@CCY             S              3
     DWMDINC           S              1
     DWSPRTC           S             13  8
     DWMDINF           S              1
     DWSPRTF           S             13  8
 
     DPRTNC            S              1
     DPBOOK            S              2
     DPTRTP            S              5
     DPSUTP            S              2
     DPBRAN            S              3
     DPDEPT            S              3
     DPUSER            S             10
     DPACOF            S              2
     DPCNUM            S              6
     DPPRFC            S              4
 
     DWPTCS            S              1
     DWAUTOA           S              1
     DWAUTOY           S              1
     DPFPTF            S              1
 
     DWORLNT           S              6
     DWLOANT           S              6
     DWFSEQT           S              2
     DWFACLT           S              5
 
     DWAMTP            S              2
     DWBRTT            S              2
     DWRTSP            S             11  7
     DWPRAM            S             13  0
     DWINTA            S             13  0
     DWTAMT            S             13  0
     DWSETP            S              2  0
     DWTSEN            S             10
     DPCURR            S              3
     DPBRAT            S              2
     DWBRTE            S             11  7
     DWNACD            S              1
     DWOSBR            S              3
     DWRSTM            S              2  0
     DWRIBN            S              8
     DWRIBA            S             35
     DWROBN            S              6
     DWROCN            S              6
     DWPSTM            S              2  0
     DWRCRN            S              8
     DWRCRA            S             35
     DWRONS            S             18
     DWOSAC            S             18
     DWBASR            S             11  7
 
     DWrkPart          S              1
 
     DWRVCRC           S              1
     DWVLDT            S              5  0
 
     DCDPF             S              1  0
 
     DP@RTCD           S             10
 
     DSPRME            S             12
 
     DWFCXR            S             13  8
     DWROFXR           S              1
     DCX               S              1  0
     DOFCXRT           S             15  9
     DPRAM_Fac         S             13  0
 
     DZMDI1            S              1
 
     DZRATE1           S             13  8
     DZNBDP1           S              1  0
 
     DZMDI2            S              1
     DZRATE2           S             13  8
     DZNBDP2           S              1  0
 
     DZRATEX           S             13  8
     DZMDIX            S              1
 
     DZEXCH            S             13  8
     DZMD              S              1
     DZAMTCI           S             15  0
     DZCCYI            S              3
     DZCCYO            S              3
     DZCDPI            S              1  0
     DZCDPO            S              1  0
     DZAMTCO           S             15  0
 
     DWrkPRAMS         S             13  0
 
     DENDAY            S              5  0
     DDAYNO            S              5  0
 
     DFCBAL            S             13  0
 
     DWKSWRI           S              1
 
     DX                S              2  0
     DW                S              3  0
 
     DICUSTN           S              6
 
     DWTCCY            S              3
     DWCMDI            S              1
     DWCAXR            S             13  8
 
     DWRVCRF           S              1
 
     DPOPTN            S              7
 
     DCDPC             S              1  0
 
     DWTRCA            S              1
 
     DZZAMT            S             15  3
     DZZAMTI           S             15  0
     DZZAMTD           S              3  0
 
     DZZTOTI           S             15  0
     DZZTOTD           S              3  0
 
     DZZWK2            S              4  0
     DZZWK3            S             15  0
     DZZNEGD           S              5
 
     D@BRCA            S              3
     DW#1ST3           S              3
     DPCNEXT           S              8
     DW1ST11           S             11
     DWPCRF            S             15
 
     DCGL058           S              1
     DCLE028           S              1
 
     DI                S              3  0
     D WaitFlag        S              1    INZ(*BLANKS)
 
      ** System Value Parameter
     D RunAsIdentity   S              1A
     D SeqFlg          S              1A
     D POP01           S             20A
     D PVL01           S            200A
     D POP02           S             20A
     D PVL02           S            200A
     D POP03           S             20A
     D PVL03           S            200A
     D POP04           S             20A
     D PVL04           S            200A
     D POP05           S             20A
     D PVL05           S            200A
     D POP06           S             20A
     D PVL06           S            200A
     D POP07           S             20A
     D PVL07           S            200A
     D POP08           S             20A
     D PVL08           S            200A
     D POP09           S             20A
     D PVL09           S            200A
     D POP10           S             20A
     D PVL10           S            200A
     D LOANTYPE        S              4A
 
     DWFECU            S              6A
     DWFFAC            S              3  0
     DWORLN            S              6  0
     DWFCTY            S              5  0
     DWFLNO            S              6
 
     D PRtCd           S              7
     D PErrMsg         S             30A
     D PRequest        S             10A
     D PQueueNm        S             48A
     D PMQMgr          S             48A
     D PMsgBuf         S          32000A
     D WkRespQ         S             20A
     D WkMQMgr         S             48A
     D WkUser          S             10A
     D P@Key           S              4A
     D PMode           S             10A
     D PAPIName        S            100A
     D Pformat         S            100A
     D PfldTag         S             10A
     D PfldData        S           1000A
     D PfldType        S             10A
     D PfldAttr        S             10A
      *
      ** Variables to be used in populating LEMQLGPD
     D MQTGTT          S             32A
     D MQTGTS          S              8A
     D MQSRCS          S              8A
     D MQRDNB          S              5A
     D MQACTN          S              1A
     D MQORLN          S              6A
     D MQPDPR          S             13P 0
     D MQPDIN          S             14P 0
     D MQSDAT          S              6A
     D MQLOAN          S              6A
     D MQVDAT          S              6A
     D MQSEQN          S              3A
     D MQATYP          S              2A
     D MQCNUM          S              6A
     D MQCURR          S              3A
     D MQAMNT          S             13P 0
     D MQLTYP          S              2A
     D MQSTYP          S              2A
     D MQCLAS          S              4A
 
     D WX1             S              1  0
     D W@FACL5A        S              5A
     D W@FCOD6A        S              6A
     D W@FSEQ2A        S              2A
 
      ** Establish the transaction type
     DRecordType       S              1A
     DLoan             C                   CONST('1')
     DFeeLoan          C                   CONST('2')
     DFeeFacility      C                   CONST('3')
     DValidList        C                   CONST('GPLDAPVL')
 
     DTXT01            C                   CONST('Original Loan Ref ')
     DTXT02            C                   CONST('Original Fee  Ref ')
 
     DPartsSold        C                   CONST('1')
     DPartsPurchase    C                   CONST('2')
 
     D TimeStamp       S               Z
      ***  Timestamp of the transaction
     D W1STPASS        S              1A
     D WSTAT           S              1A
     D WCURTIME        S               Z
     D WCURTIMEZ       S             20S 0
     D WCURTIMEC       S             20A
     D WWAITTIME       S             20A
     D WWAITTIME8A     S              8A
      *
      ** Validation List Parameter
     D PRtnCode        S              7A
     D PAction         S              1A
     D PValidList      S             10A
     D PLibrary        S             10A
     D*PUserName       S            256A                                                    MD033895
     D*PPassword1      S            256A                                                    MD033895
     D*PPassword2      S            256A                                                    MD033895
     D*PDescrptn       S             50A                                                    MD033895
     D PUserName       S            100A                                                    MD033895
     D PPassword1      S            600A                                                    MD033895
     D PPassword2      S            600A                                                    MD033895
     D PDescrptn       S           1000A                                                    MD033895
 
     D SysPrefix       S              2A
 
     D wPBSR           S              2S 0
     D wPBRT           S             11P 7
     D wPRSP           S             11P 7
     D wPRSI           S              1A
     D wPICB           S              1A
     D wIBSR           S              2S 0
     D wIBRT           S             11P 7
     D wIRSP           S             11P 7
     D wIRSI           S              1A
     D wIICB           S              1A
     D wPPROC          S              2S 0
     D wPCSP           S             11P 7
     D wPCSG           S              1A
     D wPFMT           S              7A
     D wPRFD           S              4A
     D ProcessingType  S              1A
     D ExistLEPRAT     S              1A   INZ(*OFF)
     D WINAMT          S             15  0                                                 MD049745A
     D WRATE           S             13  8                                                 MD049745A
     D WSPRT1          S             13  8                                                 MD049745A
     D WSPRT2          S             13  8                                                 MD049745A
     D WMDIN           S              1A                                                   MD049745A
     D WMDIN1          S              1A                                                   MD049745A
     D WMDIN2          S              1A                                                   MD049745A
     D WCCY1           S              3A                                                   MD049745A
     D WCCY2           S              3A                                                   MD049745A
     D WNBDP1          S              1  0                                                 MD049745A
     D WNBDP2          S              1  0                                                 MD049745A
     D WOUTAMT         S             15  0                                                 MD049745A
     D WIND1           S              1A                                                   MD049745A
     D WREV            S              1A                                                   MD049745A
                                                                                            MD022465
     D CurrKey         S                   LIKE (A6CYCD)                                    MD022465
     D CurrIdx         S              3  0 INZ(1)                                           MD022465
     D TrailIdx        S              3  0 INZ(1)                                           MD022465
     D CurrCache       S                   INZ LIKE(A6CYCD)                                 MD022465
     D                                     DIM(250) ASCEND                                  MD022465
      ** Key for Currency Details (Full Cache)                                              MD022465
                                                                                            MD022465
     D DSCurr        E DS                  INZ EXTNAME(SDCURRPD)                            MD022465
     D                                     DIM(250) QUALIFIED                               MD022465
     ** Storage for Currency Details (Full Cache)                                           MD022465
      *                                                                                    MD022807B
     D @@PDCL          S              6A   INZ(*BLANKS)                                    MD022807B
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
     C     *DTAARA       DEFINE                  LEPDCL
     C     *LOCK         IN        LEPDCL
     C                   MOVE      PDCLTS        WPDCLTS
     C                   MOVE      BJRDNB        WBJRDNB
     C                   MOVE      BJRDNB        MQRDNB
     C                   EVAL      WPGM = 'LE000473'
     C                   EXSR      SrResetSeq                                               MD023203
      *
      ** Reset return code
      *
     C                   EVAL      WRETCD = *BLANKS
     C                   EVAL      WLSEQ = *ZEROS
      *
      ** Check whether the processing is for a Loan or for a Fee
      *
     C                   SELECT
     C                   WHEN      W@TYPE = 'L'
     C                   EXSR      SRLOAN
     C                   WHEN      W@TYPE = 'F'
     C                   EXSR      SRFEE
     C                   OTHER
     C                   EVAL      WRETCD = '*ERROR'
     C                   ENDSL
      *
      ** Return to Caller
      *
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLOAN - Loans Processing                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPDCALC, SRPDCLUP & SRPDCLIN                          *
      *                                                               *
      *****************************************************************
     C     SRLOAN        BEGSR
      *
      ** Check if PDCLs already exists
      *
     C                   CLEAR                   P2_YPSIIN
     C                   MOVE      'N'           P2_PDCLF
     C     W@LOAN        SETLL     LEPDUELA
     C     W@LOAN        READE     LEPDUELA                               85
     C     *IN85         IFEQ      *OFF
     C                   MOVE      'Y'           P2_PDCLF
     C                   ENDIF
      *
      ** Check original loan
      *
     C     W@LOAN        CHAIN     CLOAN
     C                   IF        NOT(%FOUND(CLOAN))
     C                   EVAL      WRETCD = '*ERROR'
     C                   MOVE (P)  W@LOAN        DBKEY
     C                   EVAL      DBFILE = 'CLOAN'
     C                   EVAL      DBASE = 001
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     W@LOAN        CHAIN     CLOANC
     C                   IF        NOT(%FOUND(CLOANC))
     C                   EVAL      WRETCD = '*ERROR'
     C                   MOVE (P)  W@LOAN        DBKEY
     C                   EVAL      DBFILE = 'CLOANC'
     C                   EVAL      DBASE = 002
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   EVAL      WLSEQ = C_FSEQ
      *
      ** Find Type/Subtype information
      *
     C                   CALL      'AOLOANR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      C_LTYP        PLoanType
     C                   PARM      C_SUTP        PLSubType
     C                   PARM      C_CLAS        PLClass
     C     SDLOAN        PARM      SDLOAN        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C     C_LTYP        CAT       C_SUTP        DBKEY
     C                   MOVE      C_CLAS        DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 003
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      ProcessingType = *BLANKS                                MD021423B
     C                   IF        AYLNPT = 64 OR
     C                             AYLNPT = 65 OR
     C                             AYLNPT = 68 OR
     C                             AYLNPT = 71
     C                   EVAL      ProcessingType = PartsPurchase
     C                   ELSEIF    AYLNPT = 66 OR
     C                             AYLNPT = 72
     C                   EVAL      ProcessingType = PartsSold
     C                   ENDIF
      *
      ** Find range for PDCL Principal or Total loan
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AYPPLT        PLoanType
     C                   PARM      AYPPLS        PLSubType
     C                   PARM      AYPPLC        PLClass
     C     SDLOAN1       PARM      SDLOAN1       DSFDY
     C                   IF        @RTCD <> *BLANKS
     C     AYPPLT        CAT       AYPPLS        DBKEY
     C                   MOVE      AYPPLC        DBKEY
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 004
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Find range for PDCL Interest loan
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      AYIPLT        PLoanType
     C                   PARM      AYIPLS        PLSubType
     C                   PARM      AYIPLC        PLClass
     C     SDLOAN2       PARM      SDLOAN2       DSFDY
      *
      ** No DB Err if Interest range not found,
      ** use Principal range instead
      *
     C                   IF        @RTCD <> *BLANKS
     C                   MOVE      @AYRANG       @2AYRANG
     C                   ENDIF
      *
      ** Override fields if penalties are present
      *
     C                   EVAL      ExistLEPRAT = *OFF
     C     W@LOAN        CHAIN     LEPRATL1
     C                   IF        %FOUND
 
     C                   EVAL      ExistLEPRAT = *ON
     C                   IF        B2CAPI <> ' '
     C                   EVAL      AYCAPI = B2CAPI
     C                   ENDIF
 
     C                   IF        B2SPLI <> ' '
     C                   EVAL      AYSIIN = B2SPLI
     C                   ENDIF
 
     C                   EVAL      AYPBSR = B2PBSR
 
     C                   EVAL      AYPBRT = B2PBRT
 
     C                   EVAL      AYPRSP = B2PRSP
 
     C                   EVAL      AYPRSI = B2PRAT
 
     C                   IF        B2PICB <> 0
     C                   EVAL      AYPICB = B2PICB
     C                   ENDIF
 
     C                   EVAL      AYIBSR = B2IBSR
     C                   EVAL      AYIRSP = B2IRSP
 
     C                   EVAL      AYIBRT = B2IBRT
 
     C                   EVAL      AYIRSI = B2IRAT
 
     C                   IF        B2IICB <> 0
     C                   EVAL      AYIICB = B2IICB
     C                   ENDIF
 
     C                   IF        B2POPR <> ' '
     C                   EVAL      AYPOPR = B2POPR
     C                   ENDIF
     C                   ENDIF
      ** Set up work fields
     C                   EVAL      WINT = W@INT
     C                   EVAL      WPDAMT = W@PDAMT
     C                   EVAL      WCPAM = 0
     C                   EVAL      WAV = W@AV
 
      ** set return fields
 
     C                   EVAL      W@OPDAM = WPDAMT
     C                   EVAL      W@OPDINT = WINT
 
      ** Clear Principal Amount fields if it is an Interest PDCL
 
     C                   IF        W@DCLTYP = 'I'
     C                   EVAL      WPDAMT = 0
     C                   EVAL      W@PDAMT = 0
     C                   ENDIF
 
      ** if PDCL already exists, get separate indicator from file
 
     C                   IF        P2_PDCLF = 'Y'
     C                             AND P2_YPSIIN <> AYSIIN
     C                   EVAL      AYSIIN = P2_YPSIIN
     C                   ENDIF
 
      ** Clear Interest Amount fields if it is a Principal PDCL
 
     C                   IF        W@DCLTYP = 'P'
     C                   EVAL      WINT = 0
     C                   EVAL      W@INT = 0
     C                   ENDIF
 
      ** Nothing to do here and exit
 
     C                   IF        W@DCLTYP = 'I'
     C                             AND AYCAPI = 'N'
     C                             AND AYSIIN = 'N'
     C                   IF        W@TYPE = 'L'
     C                   EVAL      WRETCD = 'NOINTPD'
     C                   ENDIF
     C                   ELSE
 
      ** Amounts calculations
 
     C                   IF        AYSIIN = 'N'
     C                             AND AYCAPI = 'Y'
     C                             OR  AYSIIN = 'Y'
     C                             AND AYCAPI = 'N'
     C                   EXSR      SRPDCALC
     C                   ENDIF
 
      ** Write/Update PDCLs
 
     C                   IF        AYSIIN = 'Y'
 
      ** PDCL on PD Interest
 
     C                   EVAL      WRECI = 'D'                                              MD035433
     C                   IF        WINT > 0
     C                   EVAL      WCPAM = WINT
     C                   EVAL      WPIIN = 'I'
     C     WLOLNK        CHAIN     LEPDUEL7
     C                   IF        %FOUND
     C                   EXSR      SRPDCLUP
     C                   ELSE
     C                   MOVE      @2AYRANG      AYRANG
      *
      ** Insert PDCL
      *
     C                   EVAL      WCPAM = 0
     C                   EXSR      SRPDCLIN
     C                   ENDIF
     C                   ENDIF
      *
      ** PDCL on PD Principal
      *
     C                   IF        WPDAMT > 0
     C                   EVAL      WCPAM = WPDAMT
     C                   EVAL      WPIIN = 'P'
     C     WLOLNK        CHAIN     LEPDUEL7
     C                   IF        %FOUND
     C                   EXSR      SRPDCLUP
     C                   ELSE
     C                   MOVE      @AYRANG       AYRANG
      *
      ** Insert PDCL
     C                   EVAL      WINT = 0
     C                   EXSR      SRPDCLIN
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
      *
      ** PDCL on PD Principal and Interest
      *
     C                   EVAL      WPIIN = 'T'
     C                   EVAL      WCPAM = WPDAMT + WINT
 
     C                   EVAL      WINT  = 0
     C                   EVAL      WRECI = 'D'
     C                   EVAL      W1STPASS = 'Y'
     C                   EVAL      WSTAT    = 'S'
     C                   EVAL      WX1 = 1
     C                   DOW       WX1 <= 2
     C                   EVAL      WX1 += 1
     C*****WLOLNK        CHAIN(N)  LEPDUEL7                           99                   MD021423E
     C     WLOLNK        CHAIN     LEPDUEL7                           99                   MD021423E
     C                   IF        *IN99 = '0'
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WRECI = 'd'
     C                   ENDDO
 
     C                   IF        %FOUND
     C                   EXSR      SRPDCLUP
     C                   ELSE
     C                   MOVE      @AYRANG       AYRANG
      *
      ** Insert PDCL
     C                   EXSR      SRPDCLIN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFEE - Fee Processing                                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPDCLUP & SRPDCLIN                                    *
      *                                                               *
      *****************************************************************
     C     SRFEE         BEGSR
      *
     C                   EVAL      WAV = W@AV
     C                   EVAL      WINT = 0
     C                   EVAL      W@INT = 0
     C                   EVAL      WPDAMT = W@PDAMT
     C                   EVAL      WCPAM = W@PDAMT
     C                   EVAL      WYPLNR = *BLANKS
 
     C                   IF        W@PDAMT >= W@AV
     C                   EVAL      WCPAM = W@PDAMT
     C                   EVAL      WAV = 0
      *
      ** Retrieve Fee Code information
      *
     C                   MOVE      W@FCOD        @FECD
     C                   CALL      'AOFEER0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    @FECD
     C     SDFEE         PARM      SDFEE         DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBFILE = 'SDFEEPD'
     C                   MOVE      @FECD         DBKEY
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve base rates, penalties, ranges, etc. for all
      *
     C                   EVAL      WLTYP = AUCLTY
     C                   EVAL      WSUTP = AUCLST
     C                   EVAL      WCLAS = AUCLCL
      *
      ** Find type/subtype info
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     POptn
     C                   PARM      WLTYP         PLoanType
     C                   PARM      WSUTP         PLSubType
     C                   PARM      WCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
 
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C     WLTYP         CAT       WSUTP         DBKEY
     C                   MOVE      WCLAS         DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 006
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WPIIN = ' '
     C                   EVAL      W@FACL5A = *BLANKS
     C                   IF        W@FACL  > 0
     C                   MOVEL     W@FACL        W@FACL5A
     C                   ENDIF
     C                   EVAL      W@FCOD6A= *BLANKS
     C                   IF        W@FCOD  > 0
     C                   MOVEL     W@FCOD        W@FCOD6A
     C                   ENDIF
     C                   EVAL      W@FSEQ2A = *BLANKS
     C                   IF        W@FSEQ   > 0
     C                   MOVEL     W@FSEQ        W@FSEQ2A
     C                   ENDIF
     C                   EVAL      WRECI = 'D'
     C                   EVAL      WX1 = 1
     C                   EVAL      W1STPASS = 'Y'
     C                   EVAL      WSTAT    = 'S'
     C                   EVAL      WaitFlag = 'N'
     C                   DOW       WX1 <= 2
     C                   EVAL      WX1 += 1
     C     WFELNK        CHAIN     LEPDUFL7                           99
     C                   IF        *IN99 = '0'
     C                   IF        WRECI = 'd'
     C                   EVAL      WaitFlag = 'Y'
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
     C                   EVAL      WRECI = 'd'
     C                   ENDDO
 
     C                   IF        %FOUND
     C     WFELNK2       CHAIN(N)  CLOANLF                            99
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      @CURR = LF_CCY                                          MD049745A
     C                   ENDIF                                                             MD049745A
     C                   EXSR      SRPDCLUP
     C                   ELSE
      *
      ** Insert PDCL
      *
     C                   EXSR      SRPDCLIN
     C                   EVAL      WYPLNR = F9NALA
     C                   ENDIF
 
     C                   ELSE
      *
      ** Principal amount is less than available balance, just return
      ** to caller
      *
     C                   ENDIF
      *
      ** Set Return Fields
      *
     C                   EVAL      W@OPDAM = WPDAMT
     C                   EVAL      W@OPDINT = WINT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPDCLIN - Subroutine to insert new PDCL records              *
      *                                                               *
      * Called by: SRLOAN, SRFEE                                      *
      *                                                               *
      * Calls: setLEPDUEPDx, setLEPDUFPD, callPDCL, SrWrtSynchPD,     *
      *        SRPutMQIO & SrUpdTrailer                               *
      *                                                               *
      *****************************************************************
     C     SRPDCLIN      BEGSR
      *
      ** Read Loan
      *
     C                   EVAL      WPDCLTS += 1
     C                   MOVE      WPDCLTS       PDCLTS
     C                   OUT       LEPDCL
 
     C                   IF        W@TYPE = 'L'
     C                   EVAL      RecordType = Loan
      *
      ** Set up the link record for Loan
      *
     C                   EXSR      setLEPDUEPDx
      *
     C                   ELSE
      *
      ** Read Fee
      *
     C                   MOVE      W@CNU2        WFECU
     C                   MOVE      W@FACL        WFCTY
     C                   MOVE      W@LOAN        WFLNO
     C                   MOVE      W@FSEQ        WFSEQ
     C
     C     KFEE          CHAIN     LEFEEDL1
     C                   IF        NOT %FOUND
     C                   EVAL      WRETCD = '*ERROR'
     C                   MOVE      'KFEE'        DBKEY
     C                   EVAL      DBFILE = 'LEFEEDL1'
     C                   EVAL      DBASE = 007
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   MOVE      E_FEFACL      WLSEQ
      *
      ** Retrieve customer details
     C                   MOVEL     E_FECNUM      PCUST            10
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY'        POPTN
     C                   Parm                    PCUST
     C                   PARM      *BLANKS       PSTKEY            7
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        PRTCD <> *BLANKS
     C                             AND PRTCD <> '*NRF   '
     C                   EVAL      DBKEY = POPTN
     C                   EVAL      DBFILE = 'SDCUSTPD'
     C                   EVAL      DBASE = 008
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Retrieve Facility Details, if entered
      *
     C                   IF        W@FACL <> 0
      *
     C                   EVAL      WFCUS = W@CNU2
     C                   MOVEL     W@FACL        WFTYP
     C                   MOVE      W@FACL        WFSEQ
     C                   ENDIF
      *
      ** Retrieve Loan details, if Loan fee
      *
     C                   IF        W@LOAN <> *BLANKS
     C                   MOVE      W@LOAN        WFLNO
     C     WFLNO         CHAIN     CLOAN
     C                   IF        %FOUND
     C                   EVAL      WFCUS = C_FCUS
     C                   MOVE      C_FTYP        WFTYP
     C                   MOVE      C_FSEQ        WFSEQ
     C                   EVAL      WLSEQ = WFSEQ
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      @CURR = C_CCY                                           MD049745A
     C                   ENDIF                                                             MD049745A
     C     WFLNO         CHAIN     CLOANC
     C                   EVAL      RecordType = FeeLoan
     C                   ENDIF
     C                   ENDIF
      *
      ** Retrieve Facility
      *
     C                   MOVE      'A'           WRCDT1
     C     KFCLT         CHAIN     FCLTY
     C                   IF        NOT %FOUND
     C                   EVAL      WRETCD = '*ERROR'
     C                   MOVE      'KFCLT'       DBKEY
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 009
     C                   EXSR      *PSSR
     C                   ELSE
     C                   MOVE      'B'           WRCDT1
     C     KFCLT         CHAIN     FCLTY
     C                   IF        not %FOUND
     C                   EVAL      WRETCD = '*ERROR'
     C                   MOVE      'KFCLT'       DBKEY
     C                   EVAL      DBFILE = 'FCLTY'
     C                   EVAL      DBASE = 010
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   IF        W@LOAN = *BLANKS
     C                   EVAL      RecordType = FeeFacility
     C                   ENDIF
     C                   ENDIF
      *
      ** Set up the link record for the Fee
      *
     C                   EXSR      setLEPDUFPD
      *
      ** Update the Basel II and Reporting fields, if necessary
      *
     C                   ENDIF
      *                                                                                    MD022807B
      ** Generate next loan number                                                         MD022807B
      *                                                                                    MD022807B
     C                   EVAL      @@PDCL = *BLANKS                                        MD022807B
     C                   EXSR      SRGetLoan                                               MD022807B
     C                   MOVE      F9NALA        @@PDCL                                    MD022807B
      *
      ** Write new loan
      *
     C                   EXSR      SRDeftCLIP
      ** Send message to MQ series queue
      *
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
      *
      ** Write a record to Synch File
      *
     C                   EXSR      SrWrtSynchPD
      *                                                                                    MD021423E
      ** Base Rate Change Event 'BC'                                                       MD021423E
      *                                                                                    MD021423E
     C                   MOVE      'BC'          W#ATYP            2                        MD022465
     C     K_MQLG        CHAIN     LEMQLGLC                           98                    MD022465
     C                   IF        AYPOPR = 'Y'                                            MD021423E
     C                             AND C_RECI = 'D' AND *IN98 = '1'                         MD022465
     C                             AND (wIBSR <> 0 OR wPBSR <> 0)                          MD021423E
      *                                                                                    MD021423E
     C                   IF        YPSIIN <> 'Y'                                           MD021423E
     C                   MOVE      AYPBSR        WBRTT             2                       MD021423E
     C                   ELSE                                                              MD021423E
     C                   MOVE      AYIBSR        WBRTT                                     MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
     C                   CALLB     'AOBSRTR0'                                              MD021423E
     C                   PARM      *BLANKS       @RTCD                                     MD021423E
     C                   PARM      '*KEY    '    POPTN                                     MD021423E
     C                   PARM      C_CCY         PCURR             3                       MD021423E
     C                   PARM      WBRTT         PBRAT             2                       MD021423E
     C     SDBSRT        PARM      SDBSRT        DSSDY                                     MD021423E
     C                   IF        @RTCD = *BLANKS                                         MD021423E
     C                   IF        BJRDNB < BAVDNR                                         MD021423E
     C                   Z-ADD     BACBSR        WBRTE            11 7                     MD021423E
     C                   ELSE                                                              MD021423E
     C                   Z-ADD     BANBRT        WBRTE                                     MD021423E
     C                   ENDIF                                                             MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
     C                   EVAL      LoamType = 'BC'                                         MD021423E
     C                   EXSR      CALLLOAMBC_SC                                           MD021423E
      ** Send message to MQ series queue                                                   MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*OPEN_PUT'                                  MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*PUT'                                       MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*CLOSE'                                     MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
      ** Write a record to Synch File                                                      MD021423E
      *                                                                                    MD021423E
     C                   EXSR      SrWrtSynchBSC                                           MD021423E
      *                                                                                    MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
      ** Spread Change Event 'SC'                                                          MD021423E
      *                                                                                    MD021423E
     C                   MOVE      'SC'          W#ATYP            2                        MD022465
     C     K_MQLG        CHAIN     LEMQLGLC                           98                    MD022465
     C                   IF        AYPOPR = 'Y'                                            MD021423E
     C                             AND C_RECI = 'D' AND *IN98 = '1'                         MD022465
     C                             AND (wIRSP <> 0 OR wPRSP <> 0)                          MD021423E
      *                                                                                    MD021423E
     C                   IF        YPSIIN <> 'Y'                                           MD021423E
     C                   Z-ADD     wPRSP         WRTSP            11 7                     MD021423E
     C                   ELSE                                                              MD021423E
     C                   Z-ADD     wIRSP         WRTSP                                     MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
     C                   EVAL      LoamType = 'SC'                                         MD021423E
     C                   EXSR      CALLLOAMBC_SC                                           MD021423E
      *                                                                                    MD021423E
      ** Send message to MQ series queue                                                   MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*OPEN_PUT'                                  MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*PUT'                                       MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PRequest = '*CLOSE'                                     MD021423E
     C                   EXSR      SRPutMQIO                                               MD021423E
      *                                                                                    MD021423E
      ** Write a record to Synch File                                                      MD021423E
      *                                                                                    MD021423E
     C                   EXSR      SrWrtSynchBSC                                           MD021423E
      *                                                                                    MD021423E
     C                   ENDIF                                                             MD021423E
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * setLEPDUFPD - LEPDUFPD x Fee - Principal                      *
      *                                                               *
      *****************************************************************
     C     setLEPDUFPD   BEGSR
 
     C                   CLEAR                   LEPDUFD0
      *
      ** Primary record
     C                   MOVE      'p'           YRECI
     C**********         MOVEL     F9NALA        YPLON                                     MD022807E
     C                   MOVEL     *BLANKS       YPLON                                     MD022807E
     C**********         Z-ADD     BJRDNB        YVDAT                                      MD023162
     C                   Z-ADD     W@AVDAT       YVDAT                                      MD023162
     C                   MOVE      W@CNU2        YECNUM
     C                   MOVE      W@FACL        YEFACL
     C                   MOVE      W@FSEQ        YESEQ
     C                   MOVE      W@LOAN        YPORG
     C                   Z-ADD     WCPAM         YPCPAM
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WCPAM                                          MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   Z-ADD     0             YPDINT
     C                   MOVE      AUFAMU        YPFAMU
     C                   MOVE      'N'           YPSIIN
     C                   MOVE      'N'           YPCIIN
     C                   MOVE      E_FEBRCA      YBRCA
 
     C                   MOVE      *BLANKS       YTKPABR
     C                   MOVE      *BLANKS       YTKPACL
     C                   MOVE      *BLANKS       YTKPACY
     C                   Z-ADD     0             YTKPAAC
     C                   Z-ADD     0             YTKPASE
 
     C                   Z-ADD     0             YRIDT
     C                   Z-ADD     0             YBIDT
     C                   Z-ADD     0             YRCAT
     C                   Z-ADD     0             YBCAT
 
     C                   MOVE      'N'           YDECRE
     C                   Z-ADD     W@EDATYP      YPDVDT
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVEL(P)  WIUSR         YPIUSE
     C                   MOVE      'C'           YPCBIC
     C                   Z-ADD     W@ORIGP       YPOREP
     C                   Z-ADD     0             YPOREI
     C                   Z-ADD     0             YPOSEQ
     C                   MOVEL     WPDCLSEQ      YPFRNT
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   WRITE     LEPDUFD0
      *
      ** Details record
     C                   MOVE      'd'           YRECI
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   Z-ADD     W@ORIGP       YPOREP
     C                   WRITE     LEPDUFD0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * setLEPDUEPDx - LEPDUEPD x Loan - Principal/Interest           *
      *                                                               *
      *****************************************************************
     C     setLEPDUEPDx  BEGSR
     C                   CLEAR                   LEPDUED0
      ** Details record
     C                   MOVE      'D'           YRECI
     C**********         MOVEL     F9NALA        YPLON                                     MD022807E
     C                   MOVEL     *BLANKS       YPLON                                     MD022807E
     C**********         Z-ADD     BJRDNB        YVDAT                                      MD023162
     C                   Z-ADD     W@AVDAT       YVDAT                                      MD023162
     C                   MOVEL     W@LOAN        YPORG
     C                   MOVE      C_BRCA        YBRCA
     C                   MOVE      WPIIN         YPDCT
     C                   Z-ADD     WCPAM         YPCPAM
     C                   Z-ADD     WINT          YPDINT
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WCPAM                                          MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WINT                                           MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPDINT = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   MOVE      AYFAMU        YPFAMU
     C                   MOVE      'N'           YDECRE
     C                   MOVE      AYSIIN        YPSIIN
     C                   MOVE      AYCAPI        YPCIIN
 
     C                   MOVE      *BLANKS       YTKPABR
     C                   MOVE      *BLANKS       YTKPACL
     C                   MOVE      *BLANKS       YTKPACY
     C                   Z-ADD     0             YTKPAAC
     C                   Z-ADD     0             YTKPASE
 
     C                   MOVE      *BLANKS       YTKIABR
     C                   MOVE      *BLANKS       YTKIACL
     C                   MOVE      *BLANKS       YTKIACY
     C                   Z-ADD     0             YTKIAAC
     C                   Z-ADD     0             YTKIASE
 
     C                   Z-ADD     0             YRIDT
     C                   Z-ADD     0             YBIDT
     C                   Z-ADD     0             YRCAT
     C                   Z-ADD     0             YBCAT
 
     C                   Z-ADD     W@EDATYP      YPDVDT
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVEL(P)  WIUSR         YPIUSE
     C                   MOVE      'C'           YPCBIC
     C                   Z-ADD     W@ORIGP       YPOREP
     C                   Z-ADD     W@ORIGI       YPOREI
     C                   Z-ADD     0             YPOSEQ
     C                   MOVEL     WPDCLSEQ      YPFRNT
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
 
     C                   WRITE     LEPDUED0
 
      ** Primary record
 
     C                   MOVE      'P'           YRECI
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   Z-ADD     W@ORIGP       YPOREP
     C                   Z-ADD     W@ORIGI       YPOREI
     C                   Z-ADD     W@LASN        YPOSEQ
     C                   WRITE     LEPDUED0
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPDCLUP - SR to UPDATE existing PDCLs                        *
      *                                                               *
      * Called by: SRLOAN, SRFEE                                      *
      *                                                               *
      * Calls: callLOAMPI, SrWrtSynchPI, SRPutMQIO, SrUpdTrailer      *
      *                                                               *
      *****************************************************************
     C     SRPDCLUP      BEGSR
      *
      ** Loans
      *
     C                   EVAL      WPDCLTS += 1
     C                   MOVE      WPDCLTS       PDCLTS
     C                   OUT       LEPDCL
     C                   IF        WPIIN <> ' '
      *
      ** Update the summary record
      *
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WREV = 'Y'                                              MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
                                                                                           MD049745A
     C                   EVAL      WINAMT = YPDINT                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPDINT = WOUTAMT                                        MD049745A
     C                   EVAL      WREV = ' '                                              MD049745A
     C                   ENDIF                                                             MD049745A
     C                   IF        WPIIN = 'P' OR WPIIN = 'T'
     C                   EVAL      YPCPAM = YPCPAM + WCPAM
     C                   ENDIF
     C                   IF        WPIIN = 'I' OR WPIIN = 'T'
     C                   EVAL      YPDINT = YPDINT + WINT
     C                   ENDIF
     C                   EVAL      YPFRNT= WPDCLSEQ
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
                                                                                           MD049745A
     C                   EVAL      WINAMT = YPDINT                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPDINT = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   UPDATE    LEPDUED0
 
      ** Create a new details record
      ** (only field differences are include)
 
     C                   EVAL      YRECI = 'P'
     C                   EVAL      YPCPAM = 0
     C                   IF        WPIIN = 'P' OR WPIIN = 'T'
     C                   EVAL      YPCPAM = WCPAM
     C                   ENDIF
     C                   EVAL      YPDINT = 0
     C                   IF        WPIIN = 'I' OR WPIIN = 'T'
     C                   EVAL      YPDINT = WINT
     C                   ENDIF
     C                   EVAL      YTKPACL = *BLANKS
     C                   EVAL      YTKPABR = *BLANKS
     C                   EVAL      YTKPAAC = 0
     C                   EVAL      YTKPASE = 0
     C                   EVAL      YTKPACY = *BLANKS
     C                   EVAL      YTKIACL = *BLANKS
     C                   EVAL      YTKIABR = *BLANKS
     C                   EVAL      YTKIAAC = 0
     C                   EVAL      YTKIASE = 0
     C                   EVAL      YTKIACY = *BLANKS
     C                   EVAL      YDECRE = 'N'
     C                   EVAL      YPDVDT = W@EDATYP
     C                   EVAL      YPOREP = W@ORIGP
     C                   EVAL      YPOREI = W@ORIGI
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVEL(P)  WIUSR         YPIUSE
     C                   MOVE      'C'           YPCBIC
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   Z-ADD     W@LASN        YPOSEQ
     C                   EVAL      YPFRNT= WPDCLSEQ
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
                                                                                           MD049745A
     C                   EVAL      WINAMT = YPDINT                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPDINT = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   WRITE     LEPDUED0
 
      ** Fees
 
     C                   ELSE
 
      ** Update the summary record
 
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WREV = 'Y'                                              MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   EVAL      WREV = ' '                                              MD049745A
     C                   ENDIF                                                             MD049745A
     C                   EVAL      YPCPAM = YPCPAM + WCPAM
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   EVAL      YPFRNT= WPDCLSEQ
     C                   UPDATE    LEPDUFD0
 
      ** Create a new details record
      ** (only field differences are include)
 
     C                   EVAL      YRECI = 'P'
     C                   EVAL      YPCPAM = WCPAM
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = YPCPAM                                         MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      YPCPAM = WOUTAMT                                        MD049745A
     C                   ENDIF                                                             MD049745A
     C                   EVAL      YDECRE = 'N'
     C                   EVAL      YPSIIN = 'N'
     C                   EVAL      YPCIIN = 'N'
     C                   EVAL      YTKPACL= *BLANKS
     C                   EVAL      YTKPABR= *BLANKS
     C                   EVAL      YTKPAAC= 0
     C                   EVAL      YTKPASE= 0
     C                   EVAL      YTKPACY= *BLANKS
     C                   EVAL      YPOREP = W@ORIGP
     C                   EVAL      YPDVDT = W@EDATYP
     C                   Z-ADD     BJRDNB        YLCD
     C                   MOVE      'I'           YTYLC
     C                   MOVEL(P)  WIUSR         YPIUSE
     C                   MOVE      'C'           YPCBIC
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    YPTMST
     C                   EVAL      YPFRNT= WPDCLSEQ
     C                   WRITE     LEPDUFD0
 
     C                   ENDIF
 
      ** Read Penalties for PDCL loan
 
      ** Override fields if penalties are present
 
     C     YPLON         CHAIN     LEPRATL1
 
     C                   IF        %FOUND
     C                   EVAL      AYCAPI = B2CAPI
     C                   EVAL      AYSIIN = B2SPLI
     C                   EVAL      AYPBSR = B2PBSR
     C                   EVAL      AYPBRT = B2PBRT
     C                   EVAL      AYPRSP = B2PRSP
     C                   EVAL      AYPRSI = B2PRAT
     C                   EVAL      AYPICB = B2PICB
     C                   EVAL      AYIBSR = B2IBSR
     C                   EVAL      AYIBRT = B2IBRT
     C                   EVAL      AYIRSP = B2IRSP
     C                   EVAL      AYIRSI = B2IRAT
     C                   EVAL      AYIICB = B2IICB
     C                   EVAL      AYPOPR = B2POPR
     C                   ENDIF
      *
      ** Check original loan
      *
     C                   IF        W@TYPE = 'F'
     C     YPLON         CHAIN (N) CLOAN
     C     YPLON         CHAIN     CLOANC
     C                   ENDIF
      *
      ** PI Loan Amendment
      *
     C                   EXSR      callLOAMPI
      *
      ** Write a record to Synch File
      *
     C                   EXSR      SrWrtSynchPI
      *
      ** Send message to MQ series queue
      *
     C                   IF        MQLOAN <> *BLANKS
     C                   EVAL      PRequest = '*OPEN_PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*PUT'
     C                   EXSR      SRPutMQIO
      *
     C                   EVAL      PRequest = '*CLOSE'
     C                   EXSR      SRPutMQIO
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPDCALC - SR to reset amounts when PDCLs are created         *
      *                                                               *
      *****************************************************************
     C     SRPDCALC      BEGSR
     C                   EVAL      WAV = W@AV
     C                   IF        W@INT > 0
     C                             AND W@INT >= W@AV
     C                   EVAL      WINT = WINT - W@AV
     C                   EVAL      WAV = 0
     C                   ENDIF
 
     C                   IF        W@INT > 0
     C                             AND W@INT < W@AV
     C                   EVAL      WAV = WAV - WINT
     C                   EVAL      WINT = 0
     C                   ENDIF
 
     C                   IF        W@PDAMT > 0
     C                             AND W@PDAMT >= WAV
     C                   EVAL      WPDAMT = WPDAMT - WAV
     C                   EVAL      WAV = 0
     C                   ENDIF
 
     C                   IF        W@PDAMT > 0
     C                             AND W@PDAMT < WAV
     C                   EVAL      WAV = WAV - WPDAMT
     C                   EVAL      WPDAMT = 0
     C                   ENDIF
 
      ** set return fields
 
     C                   EVAL      W@OPDAM = WPDAMT
     C                   EVAL      W@OPDINT = WINT
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * ChkSysValue - Check if Customer-Level Fees will be            *
      *                condsidered                                    *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: SRPDCLUP & SRPDCLIN                                    *
      *                                                               *
      *****************************************************************
 
     C     ChkSysValue   BEGSR
 
      ** Check if Window Maintenance is activated
 
     C                   EVAL      @RTCD = *BLANKS
     C                   EVAL      POP01 = 'PDCLAccSeqNo'
     C                   EVAL      PVL01 = *BLANKS
 
     C                   CALL      'AOSVALR0'
     C                   PARM                    @RTCD
     C                   PARM                    POP01
     C                   PARM                    PVL01
     C                   PARM      *BLANKS       POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM      *BLANKS       POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM      *BLANKS       POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM      *BLANKS       POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM      *BLANKS       POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM      *BLANKS       POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
 
     C                   EVAL      SeqFlg = *BLANKS
     C                   IF        @RTCD = *BLANKS
     C                   MOVEL     PVL01         SeqFlg
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPutMQIO - Put message to MQ Series queue                   *
      *                                                               *
      * Called by: SRPDCLIN, SRPDCLIN                                 *
      *                                                               *
      * Calls: GPMQMIO                                                *
      *                                                               *
      *****************************************************************
     C     SRPutMQIO     BEGSR
      *
     C                   CALL      'GPMQMIO'
     C                   PARM      *BLANKS       WRETCD
     C                   PARM                    PErrMsg
     C                   PARM                    PRequest
     C                   PARM      PWIPQueue     PQueueNm
     C                   PARM                    PMsgBuf
     C                   PARM                    P@Key
     C                   PARM      WkMQMgr       PMQMgr
      *
     C                   IF        WRETCD <> *BLANKS OR PErrMsg <> *BLANKS
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  callLOAMPI   - Build/Prepare the transaction date and        *
      *                 format to XML.                                *
      *                 This is for the Principal Increase 'PI'       *
      *                                                               *
      * Called by: SRPDCLUP                                           *
      *                                                               *
      * Calls: SRFmtWMsg                                              *
      *                                                               *
      *****************************************************************
     C     callLOAMPI    BEGSR
      *
      ** LELOAMPD
      *
     C                   EVAL      PMode    = '*CLEAR'
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PMode    = '*ENTER'
     C                   EVAL      PAPIName = 'WRITE!MIDAS.LOAM'
     C                   EVAL      PFormat  = 'LOAM'
      *
     C                   EVAL      PFldTag  = 'APTGTTYPE'
     C                   EVAL      MQTGTT = 'LOAM'
     C                   EVAL      PFldData = 'LOAM'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APTGTSYS'
     C                   EVAL      PFldData = 'MIDAS'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EVAL      MQTGTS = 'MIDAS'                                         MD022465
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APSRCSYS'
     C                   EVAL      PFldData = 'MIDASCOB'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EVAL      MQSRCS = 'MIDASCOB'                                      MD022465
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APFOTRANID'
     C                   EVAL      PFldData = WPDCLSeq
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APRPRLOCN'
     C                   EVAL      PFldData = 'B'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APRPYQUEUE'
     C                   EVAL      PFldData = WkRespQ
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   IF        RunAsIdentity = 'N'
 
     C                   EVAL      PFldTag  = 'APUSERID'
     C                   EVAL      PFldData = WkUser
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APPASSWORD'
     C                   EVAL      PFldData = PPassword1
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   ENDIF
      *
     C                   EVAL      PFldTag  = 'DDACTN'
     C                   EVAL      PFldData = 'I'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDLOAN'
     C                   EVAL      PFldData = YPLON
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   MOVEL     YPLON         MQLOAN
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDVDAT'
     C                   IF        W@EDATYP > YVDAT
     C                   MOVEL     W@EDATYP      PDate             5 0
     C                   EXSR      ConvertDate
     C                   MOVEL     ConvertedDT   PFldData
     C                   MOVEL     W@EDATYP      MQVDAT
     C                   ELSE
     C                   MOVEL     YVDAT         PDate
     C                   EXSR      ConvertDate
     C                   MOVEL     ConvertedDT   PFldData
     C                   MOVEL     YVDAT         MQVDAT
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Get last amendment sequence number from LOAMS file
      *
     C                   Z-ADD     0             WLASN                                      MD027206
     C                   IF        YPLON <> *BLANKS                                         MD027206
     C                   MOVEL     YPLON         WPLON
     C**********         Z-ADD     BJRDNB        WSDAT                                     MD022807E
     C                   MOVEL     MQVDAT        WSDAT                                     MD022807E
     C                   Z-ADD     0             WLASN
     C     KLOAM         SETGT     LOAMS
     C     KLOAM         READPE(N) LOAMS                                  79
     C                   IF        *IN79 = *OFF
     C                   IF        LA_RECI <> 'T'
     C                   EVAL      WLASN = LA_LASN + 1
     C                   ELSE
     C                   EVAL      WLASN = 1
     C                   ENDIF
     C                   ELSE
     C     KLOAM         SETLL     HISTSL0                                                 MD022807A
     C     KLOAM         READE(N)  HISTSL0                                79               MD022807A
     C                   IF        *IN79 = *OFF                                            MD022807A
     C                   Z-ADD     0             WLASN                                     MD022807E
     C******IN99         DOWEQ     '0'                                           MD022807A MD022807B
     C     *IN79         DOWEQ     '0'                                                     MD022807B
     C**********         IF        HS_AMTP = 'PI'                                MD022807A MD022807E
     C                   IF        (HS_AMTP = 'LS' or HS_AMTP = 'PI'                       MD022807E
     C                              or HS_AMTP = 'SC' or HS_AMTP = 'BC'                    MD022807E
     C                              or HS_AMTP = 'SA') and HS_LCD = BJRDNB                 MD022807E
     C**********         Z-ADD     HS_LASN       WLASN                           MD022807A MD022807E
     C                   ADD       1             WLASN                                     MD022807E
     C                   ENDIF                                                             MD022807A
     C     KLOAM         READE(N)  HISTSL0                                79               MD022807A
     C                   ENDDO                                                             MD022807A
     C                   ADD       1             WLASN                                     MD022807A
     C                   ELSE                                                              MD022807A
     C                   EVAL      WLASN = 1
     C                   ENDIF                                                             MD022807A
     C                   ENDIF
      *                                                                                     MD023596
     C                   IF        WLASN < 800                                              MD023596
     C                   EVAL      WLASN = 800                                              MD023596
     C                   ENDIF                                                              MD023596
      *
      ** Check sequence of newly created principal increase details
      *
     C                   MOVEL     YPLON         W#LON             6
     C                   Z-ADD     BJRDNB        W#DAT             5 0
     C                   Z-ADD     0             W#LAS             3 0
     C     KLOAM2        SETGT     LELOAND0
     C     KLOAM2        READPE(N) LELOAND0                               80
     C                   IF        *IN80 = *OFF
     C                   EVAL      W#LAS = PILASN + 1
     C                   ENDIF
     C                   IF        W#LAS > WLASN
     C                   EVAL      WLASN = W#LAS
     C                   ENDIF
 
      ** Write Loan details in temporary file LELOANPI
 
     C                   EVAL      PILNRF = W#LON
     C                   EVAL      PIVDAT = W#DAT
     C                   EVAL      PILASN = WLASN
     C                   WRITE     LELOAND0
     C                   ENDIF                                                              MD027206
      *
     C                   EVAL      PFldTag  = 'DDSEQN'
     C                   MOVEL     WLASN         PFldData
     C                   MOVEL     WLASN         MQSEQN
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDATYP'
     C                   EVAL      PFldData = 'PI'
     C                   EVAL      MQATYP = 'PI'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDCNUM'
     C                   EVAL      PFldData = C_CNUM
     C                   EVAL      MQCNUM = C_CNUM
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBRAT'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRTSP'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDCURR'
     C                   EVAL      PFldData = C_CCY
     C                   MOVEL     C_CCY         MQCURR
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      @CURR = C_CCY
     C                   IF        @CURR <> *BLANKS                                         MD022465
     C                   EXSR      SrChkCurr
     C                   ENDIF                                                              MD022465
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WCPAM                                          MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      WCPAM = WOUTAMT                                         MD049745A
     C                   ENDIF                                                             MD049745A
     C                   MOVEL     WCPAM         ZFLD15
     C                   EXSR      SrConvAmt
     C                   EVAL      PFldData = %TRIM(ZOUT21)
     C                   EVAL      MQAMNT   = WCPAM
     C                   EVAL      PFldTag  = 'DDAMNT'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSTPA'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSPI1'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSPI2'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSPI3'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDFRAT'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSTYP'
     C                   MOVE      C_SUTP        MQSTYP
     C                   EVAL      PFldData = C_SUTP
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDMDAT'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDFTP'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDFST'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSTAL'
     C**********         EVAL      PFldData = *BLANK                                        MD049078
     C                   EVAL      PFldData = C_STAL                                        MD049078
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDFXRT'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDFRSP'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBASR'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSLTP'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSLST'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDLTYP'
     C                   EVAL      PFldData = C_LTYP
     C                   MOVE      C_LTYP        MQLTYP
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDCLAS'
     C                   EVAL      PFldData = C_CLAS
     C                   MOVE      C_CLAS        MQCLAS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDFCL'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDSLCL'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** LELOA2PD
      *
     C                   EVAL      PFldTag  = 'DDNRLI'
     C                   EVAL      PFldData = 'N'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDROLN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDROSN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDROBR'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRORC'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDASTS'
     C                   EVAL      PFldData = 'A'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDLUTN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** SDESSPPD
      *
     C                   EVAL      PFldTag  = 'DDPSCY'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C**********         EVAL      PFldTag  = 'DDPSTM'                                      MD022465
     C**********         IF        C_PTYP = 66                                              MD022465
     C**********                   OR C_PTYP = 69                                           MD022465
     C**********                   OR C_PTYP = 72                                           MD022465
     C**********                   AND CLE005 = 'Y'                                         MD022465
     C**********         EVAL      PFldData = *BLANK                                        MD022465
     C**********         ELSE                                                               MD022465
     C**********         EVAL      PFldData = *BLANK                                        MD022465
     C**********         ENDIF                                                              MD022465
     C**********         EVAL      PFldType = *BLANK                                        MD022465
     C**********         EVAL      PFldAttr = *BLANK                                        MD022465
     C**********         EXSR      SRFmtWMsg                                                MD022465
      **********                                                                            MD022465
     C**********         EVAL      PFldTag  = 'DDPONX'                                      MD022465
     C**********         IF        C_PSTM > 0                                               MD022465
     C**********         EVAL      PFldData = *BLANK                                        MD022465
     C**********         ELSE                                                               MD022465
     C**********         EVAL      PFldData = *BLANK                                        MD022465
     C**********         ENDIF                                                              MD022465
     C**********         EVAL      PFldType = *BLANK                                        MD022465
     C**********         EVAL      PFldAttr = *BLANK                                        MD022465
     C**********         EXSR      SRFmtWMsg                                                MD022465
      *                                                                                     MD022465
     C**********         IF        W@TYPE = 'L'                                    MD022465 MD022807
     C**********         EVAL      RecordType = Loan                               MD022465 MD022807
     C**********         ENDIF                                                     MD022465 MD022807
      *                                                                                     MD022465
     C**********         SELECT                                                    MD022465 MD022807
     C**********         WHEN      BlockCredit = 'N'                               MD022465 MD022807
      *                                                                                     MD022465
      ** Pay - settlement method                                                            MD022465
     C**********         SELECT                                                    MD022465 MD022807
     C**********         WHEN      RecordType = Loan                               MD022465 MD022807
     C**********         MOVE      C_RSTM        PSTMX             2               MD022465 MD022807
     C**********         OTHER                                                     MD022465 MD022807
     C**********         MOVE      E_RSTM        PSTMX                             MD022465 MD022807
     C**********         ENDSL                                                     MD022465 MD022807
     C**********         MOVEL     PSTMX         PFldData                          MD022465 MD022807
     C**********         EVAL      PFldTag  = 'DDPSTM'                             MD022465 MD022807
     C**********         EVAL      PFldType = *BLANK                               MD022465 MD022807
     C**********         EVAL      PFldAttr = *BLANK                               MD022465 MD022807
     C**********         EXSR      SRFmtWMsg                                       MD022465 MD022807
      *                                                                                     MD022465
      ** PONS                                                                               MD022465
     C**********         SELECT                                                    MD022465 MD022807
     C**********         WHEN      RecordType = Loan                               MD022465 MD022807
     C**********         IF        C_RSTM = 05                                     MD022465 MD022807
     C**********         SELECT                                                    MD022465 MD022807
     C**********         WHEN      ProcessingType = PartsSold                      MD022465 MD022807
     C**********         EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_RONS)        MD022465 MD022807
     C**********         OTHER                                                     MD022465 MD022807
     C**********         EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_RONS)        MD022465 MD022807
     C**********         ENDSL                                                     MD022465 MD022807
     C**********         ELSE                                                      MD022465 MD022807
     C**********         MOVEL     C_RONS        PFldData                          MD022465 MD022807
     C**********         ENDIF                                                     MD022465 MD022807
     C**********         OTHER                                                     MD022465 MD022807
     C**********         IF        E_RSTM = 05                                     MD022465 MD022807
     C**********         EVAL      PFldData = %TRIM(E_OSDB) + %TRIM(E_RONS)        MD022465 MD022807
     C**********         ELSE                                                      MD022465 MD022807
     C**********         MOVEL     E_RONS        PFldData                          MD022465 MD022807
     C**********         ENDIF                                                     MD022465 MD022807
     C**********         ENDSL                                                     MD022465 MD022807
     C**********         EVAL      PFldTag  = 'DDPONX'                             MD022465 MD022807
     C**********         EVAL      PFldType = *BLANK                               MD022465 MD022807
     C**********         EVAL      PFldAttr = *BLANK                               MD022465 MD022807
     C**********         EXSR      SRFmtWMsg                                       MD022465 MD022807
     C**********         EVAL      MQACTN = *BLANKS                                MD022465 MD022807
      *                                                                                     MD022465
     C**********         OTHER                                                     MD022465 MD022807
     C**********         EVAL      MQACTN = 'W'                                    MD022465 MD022807
     C**********         MOVEL     '00'          PFldData                          MD022465 MD022807
     C**********         EVAL      PFldTag  = 'DDPSTM'                             MD022465 MD022807
     C**********         EVAL      PFldType = *BLANK                               MD022465 MD022807
     C**********         EVAL      PFldAttr = *BLANK                               MD022465 MD022807
     C**********         EXSR      SRFmtWMsg                                       MD022465 MD022807
     C**********         ENDSL                                                     MD022465 MD022807
      *                                                                                     MD022807
     C                   EVAL      MQACTN = *BLANKS                                         MD022807
     C     YPLON         CHAIN (N) CLOAN                              99                    MD022807
     C     YPLON         CHAIN (N) CLOANC                             99                    MD022807
     C                   EVAL      ProcessingType = *BLANKS                                 MD022807
     C                   IF        C_PTYP = 64 OR                                           MD022807
     C                             C_PTYP = 65 OR                                           MD022807
     C                             C_PTYP = 68 OR                                           MD022807
     C                             C_PTYP = 71                                              MD022807
     C                   EVAL      ProcessingType = PartsPurchase                           MD022807
     C                   ELSEIF    C_PTYP = 66 OR                                           MD022807
     C                             C_PTYP = 72                                              MD022807
     C                   EVAL      ProcessingType = PartsSold                               MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
      ** RONS                                                                               MD022807
     C                   IF        C_RSTM = 05                                              MD022807
     C                   SELECT                                                             MD022807
     C                   WHEN      ProcessingType = PartsSold                               MD022807
     C                   EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_RONS)                 MD022807
     C                   OTHER                                                              MD022807
     C                   EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_RONS)                 MD022807
     C                   ENDSL                                                              MD022807
     C                   ELSE                                                               MD022807
     C                   MOVEL     C_RONS        PFldData                                   MD022807
     C                   ENDIF                                                              MD022807
      *                                                                                     MD022807
     C                   EVAL      PFldTag  = 'DDRONX'                                      MD022807
     C                   EVAL      PFldType = *BLANK                                        MD022807
     C                   EVAL      PFldAttr = *BLANK                                        MD022807
     C                   EXSR      SRFmtWMsg                                                MD022807
      *                                                                                     MD022807
      *                                                                                     MD022807
     C                   EVAL      PFldTag  = 'DDRSTM'                                      MD022807
     C                   MOVEL     C_RSTM        PFldData                                   MD022807
     C                   EVAL      PFldType = *BLANK                                        MD022807
     C                   EVAL      PFldAttr = *BLANK                                        MD022807
     C                   EXSR      SRFmtWMsg                                                MD022807
      *                                                                                    MD022807C
      ** Default PSTM and PONX to '00' and *blanks                                         MD022807C
      *                                                                                     MD022807
      ** PONS                                                                               MD022807
     C**********         IF        C_PSTM = 05                                    MD022807 MD022807C
     C**********         SELECT                                                   MD022807 MD022807C
     C**********         WHEN      ProcessingType = PartsSold                     MD022807 MD022807C
     C**********         EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_PONS)       MD022807 MD022807C
     C**********         OTHER                                                    MD022807 MD022807C
     C**********         EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_PONS)       MD022807 MD022807C
     C**********         ENDSL                                                    MD022807 MD022807C
     C**********         ELSE                                                     MD022807 MD022807C
     C**********         MOVEL     C_PONS        PFldData                         MD022807 MD022807C
     C**********         ENDIF                                                    MD022807 MD022807C
      *                                                                                     MD022807
     C                   EVAL      PFldTag  = 'DDPONX'                                      MD022807
     C                   EVAL      PFldData = *BLANKS                                      MD022807C
     C                   EVAL      PFldType = *BLANK                                        MD022807
     C                   EVAL      PFldAttr = *BLANK                                        MD022807
     C                   EXSR      SRFmtWMsg                                                MD022807
      *                                                                                     MD022807
      *                                                                                     MD022807
     C                   EVAL      PFldTag  = 'DDPSTM'                                      MD022807
     C**********         MOVEL     C_PSTM        PFldData                         MD022807 MD022807C
     C                   EVAL      PFldData = '00'                                         MD022807C
     C                   EVAL      PFldType = *BLANK                                        MD022807
     C                   EVAL      PFldAttr = *BLANK                                        MD022807
     C                   EXSR      SRFmtWMsg                                                MD022807
      *
     C                   EVAL      PFldTag  = 'DDRVNO'
     C                   EVAL      PFldData = *BLANKS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDCVMR'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPOCN'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPOBN'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRCRN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRCRA'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPIBN'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPIBA'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDAWBN'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDAWBA'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBENN'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBENA'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDTP1'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDTP2'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDTP3'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDTP4'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDDCHG'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDIC72'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB1'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB2'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB3'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB4'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB5'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDBTB6'
     C                   IF        C_PSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPMAC'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPEXR'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDPEXI'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** SDESSPRD
      *
     C                   EVAL      PFldTag  = 'DDRSCY'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRSTM'
     C                   IF        C_PTYP = 66
     C                             OR C_PTYP = 69
     C                             OR C_PTYP = 72
     C                             AND CLE005 = 'Y'
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRONX'
     C                   IF        C_RSTM > 0
     C                   EVAL      PFldData = *BLANK
     C                   ELSE
     C                   EVAL      PFldData = *BLANK
     C                   ENDIF
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRIBN'
     C                   EVAL      PFldData = *BLANKS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRIBA'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDROBN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDROCN'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDRMAC'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDREXR'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'DDREXI'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'AUTH'
     C                   EVAL      PFldData = 'Y'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'FILLER'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APNARV'
     C                   EVAL      PFldData = *BLANK
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PMode    = '*RETURN'
     C                   EXSR      SRFmtWMsg
      *
     C                   ENDSR
      *****************************************************************                    MD021423E
      /EJECT                                                                               MD021423E
      *****************************************************************                    MD021423E
      *                                                               *                    MD021423E
      *  CALLLOAMBC_SC - Build/Prepare the transaction date and       *                    MD021423E
      *                 format to XML.                                *                    MD021423E
      *                 This is for the Base Rate Change 'BC'         *                    MD021423E
      *                 and Spread Rate Change 'SC'                   *                    MD021423E
      *                                                               *                    MD021423E
      * Called by: SRPDCLIN                                           *                    MD021423E
      *                                                               *                    MD021423E
      * Calls: SRFmtWMsg                                              *                    MD021423E
      *                                                               *                    MD021423E
      *****************************************************************                    MD021423E
     C     CALLLOAMBC_SC BEGSR                                                             MD021423E
      *                                                                                    MD021423E
     C     *LOCK         IN        LEPDCL                                                  MD021423E
     C                   MOVE      PDCLTS        WPDCLTS                                   MD021423E
     C                   MOVE      BJRDNB        WBJRDNB                                   MD021423E
     C                   MOVE      BJRDNB        MQRDNB                                    MD021423E
     C                   EVAL      WPDCLTS += 1                                            MD021423E
     C                   MOVE      WPDCLTS       PDCLTS                                    MD021423E
     C                   OUT       LEPDCL                                                  MD021423E
      *                                                                                    MD021423E
     C                   MOVEL     W@LOAN        MQORLN                                    MD021423E
     C                   EVAL      MQACTN = *BLANKS                                        MD021423E
     C                   EVAL      MQPDPR = *ZEROS                                         MD021423E
     C                   EVAL      MQPDIN = *ZEROS                                         MD021423E
      *                                                                                    MD021423E
      ** LELOAMPD                                                                          MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PMode    = '*CLEAR'                                     MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PMode    = '*ENTER'                                     MD021423E
     C                   EVAL      PAPIName = 'WRITE!MIDAS.LOAM'                           MD021423E
     C                   EVAL      PFormat  = 'LOAM'                                       MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APTGTTYPE'                                  MD021423E
     C                   EVAL      PFldData = 'LOAM'                                       MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EVAL      MQTGTT = 'LOAM'                                         MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APTGTSYS'                                   MD021423E
     C                   EVAL      PFldData = 'MIDAS'                                      MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EVAL      MQTGTS = 'MIDAS'                                        MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APSRCSYS'                                   MD021423E
     C                   EVAL      PFldData = 'MIDASCOB'                                   MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EVAL      MQSRCS = 'MIDASCOB'                                     MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APFOTRANID'                                 MD021423E
     C                   EVAL      PFldData = WPDCLSeq                                     MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APRPRLOCN'                                  MD021423E
     C                   EVAL      PFldData = 'B'                                          MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APRPYQUEUE'                                 MD021423E
     C                   EVAL      PFldData = WkRespQ                                      MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   IF        RunAsIdentity = 'N'                                     MD021423E
                                                                                           MD021423E
     C                   EVAL      PFldTag  = 'APUSERID'                                   MD021423E
     C                   EVAL      PFldData = WkUser                                       MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'APPASSWORD'                                 MD021423E
     C                   EVAL      PFldData = PPassword1                                   MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
                                                                                           MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDACTN'                                     MD021423E
     C                   EVAL      PFldData = 'I'                                          MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDRECI'                                     MD021423E
     C                   EVAL      PFldData = 'D'                                          MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDLOAN'                                     MD021423E
     C                   EVAL      PFldData = W@LOAN                                       MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDVDAT'                                     MD021423E
     C                   MOVEL     W@AVDAT       PDate             5 0                     MD021423E
     C                   EXSR      ConvertDate                                             MD021423E
     C                   MOVEL     ConvertedDT   PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   MOVEL     ZDATE         MQSDAT                                    MD021423E
     C                   MOVEL     ZDATE         MQVDAT                                    MD021423E
      *                                                                                    MD021423E
      ** Get last amendment sequence number from LOAMS file                                MD021423E
      *                                                                                    MD021423E
     C                   Z-ADD     0             WLASN                                      MD027206
     C                   IF        W@LOAN <> *BLANKS                                        MD027206
     C                   MOVEL     W@LOAN        WPLON                                     MD021423E
     C                   Z-ADD     W@AVDAT       WSDAT                                     MD021423E
     C                   Z-ADD     0             WLASN                                     MD021423E
     C     KLOAM         SETGT     LOAMS                                                   MD021423E
     C     KLOAM         READPE(N) LOAMS                                  79               MD021423E
     C                   IF        *IN79 = *OFF                                            MD021423E
     C                   IF        LA_RECI <> 'T'                                          MD021423E
     C                   EVAL      WLASN = LA_LASN + 1                                     MD021423E
     C                   ELSE                                                              MD021423E
     C                   EVAL      WLASN = 1                                               MD021423E
     C                   ENDIF                                                             MD021423E
     C                   ELSE                                                              MD021423E
     C                   EVAL      WLASN = 1                                               MD021423E
     C                   ENDIF                                                             MD021423E
      *                                                                                    MD021423E
      ** Check sequence of newly created principal increase details                        MD021423E
      *                                                                                    MD021423E
     C                   MOVEL     W@LOAN        W#LON             6                       MD021423E
     C                   Z-ADD     W@AVDAT       W#DAT             5 0                     MD021423E
     C                   Z-ADD     0             W#LAS             3 0                     MD021423E
     C     KLOAM2        SETGT     LELOAND0                                                MD021423E
     C     KLOAM2        READPE(N) LELOAND0                               80               MD021423E
     C                   IF        *IN80 = *OFF                                            MD021423E
     C                   EVAL      W#LAS = PILASN + 1                                      MD021423E
     C                   ENDIF                                                             MD021423E
     C                   IF        W#LAS > WLASN                                           MD021423E
     C                   EVAL      WLASN = W#LAS                                           MD021423E
     C                   ENDIF                                                             MD021423E
                                                                                           MD021423E
      ** Write Loan details in temporary file LELOANPI                                     MD021423E
                                                                                           MD021423E
     C                   EVAL      PILNRF = W#LON                                          MD021423E
     C                   EVAL      PIVDAT = W#DAT                                          MD021423E
     C                   EVAL      PILASN = WLASN                                          MD021423E
     C                   WRITE     LELOAND0                                                MD021423E
     C                   ENDIF                                                              MD027206
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDSEQN'                                     MD021423E
     C                   MOVEL     WLASN         PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDATYP'                                     MD021423E
     C                   EVAL      PFldData = LoamType                                     MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDCNUM'                                     MD021423E
     C                   EVAL      PFldData = C_CNUM                                       MD021423E
     C                   EVAL      MQCNUM = C_CNUM                                         MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDNACD'                                     MD021423E
     C                   EVAL      PFldData = C_NACD                                       MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   MOVEL     *BLANKS       ZFIELD           16                       MD021423E
     C                   SELECT                                                            MD021423E
     C                   WHEN      LoamType = 'BC'                                         MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDBRAT'                                     MD021423E
     C                   MOVEL     WBRTT         PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   MOVE      WBRTE         ZFIELD           16                       MD021423E
     C                   EVAL      PFldTag  = 'DDBRTE'                                     MD021423E
     C                   WHEN      LoamType = 'SC'                                         MD021423E
     C                   MOVE      WRTSP         ZFIELD           16                       MD021423E
     C                   EVAL      PFldTag  = 'DDRTSP'                                     MD021423E
      *                                                                                    MD021423E
     C                   ENDSL                                                             MD021423E
      *                                                                                    MD021423E
     C                   Z-ADD     7             ZDEC              1 0                     MD021423E
      *                                                                                    MD021423E
     C                   CALL      'ZEDIT'                                                 MD021423E
     C                   PARM                    ZFIELD                                    MD021423E
     C                   PARM                    ZDEC                                      MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldData = ZFIELD                                       MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDCURR'                                     MD021423E
     C                   MOVEL     C_CCY         PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDLTYP'                                     MD021423E
     C                   MOVEL     C_LTYP        PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   EVAL      MQSTYP  = C_LTYP                                        MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDSTYP'                                     MD021423E
     C                   MOVEL     C_SUTP        PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   EVAL      MQSTYP  = C_SUTP                                        MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PFldTag  = 'DDCLAS'                                     MD021423E
     C                   MOVEL     C_CLAS        PFldData                                  MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   EVAL      MQCLAS  = C_CLAS                                        MD021423E
                                                                                            MD049078
     C                   EVAL      PFldTag  = 'DDSTAL'                                      MD049078
     C                   EVAL      PFldData = C_STAL                                        MD049078
     C                   EVAL      PFldType = *BLANK                                        MD049078
     C                   EVAL      PFldAttr = *BLANK                                        MD049078
     C                   EXSR      SRFmtWMsg                                                MD049078
                                                                                           MD021423E
     C                   EVAL      PFldTag  = 'AUTH'                                       MD021423E
     C                   EVAL      PFldData = 'Y'                                          MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
                                                                                           MD021423E
      *                                                                                    MD021423E
     C                   EVAL      PMode    = '*RETURN'                                    MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
     C                   ENDSR                                                             MD021423E
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SRFmtWsg - Format the WIP message                             *
      *                                                               *
      * Called by: callPDCL, callLOAMPI                               *
      *                                                               *
      * Calls: GPFMT4WIP                                              *
      *                                                               *
      *****************************************************************
     C     SRFmtWMsg     BEGSR
      *
     C                   CALL      'GPFMT4WIP'
     C                   PARM                    PMode
     C                   PARM                    PAPIName
     C                   PARM                    Pformat
     C                   PARM                    PfldTag
     C                   PARM                    PfldData
     C                   PARM                    PfldType
     C                   PARM                    PfldAttr
     C                   PARM                    PMsgBuf
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrChkCurr - Check currency code                               *
      *                                                               *
      * Called by: callPDCL, callLOAMPI                               *
      *                                                               *
      * Calls: AOCURRR0                                               *
      *                                                               *
      *****************************************************************
     C     SrChkCurr     BEGSR
      *                                                                                     MD022465
      ** Use details from the array if currency in the cache,                               MD022465
      ** otherwise, retrieve details from Access Object program                             MD022465
      *                                                                                     MD022465
     C                   EVAL      CurrKey = @CURR                                          MD022465
     C                   EVAL      CurrIdx = %LOOKUP( CurrKey :                             MD022465
     C                                                CurrCache :                           MD022465
     C                                                1 : TrailIdx )                        MD022465
     C                   IF        CurrIdx > 0                                              MD022465
     C                   EVAL      SDCURR = DSCurr(CurrIdx)                                 MD022465
     C                   ELSE                                                               MD022465
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     @CURR         DBKEY
     C                   MOVEL     'SDCURRPD'    DBFILE
     C                   MOVEL     '011'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF                                                              MD022465
      *
     C                   Z-ADD     A6NBDP        ZDECS
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrConvAmt - Convert Amount to Alphanumeric                    *
      *                                                               *
      * Called by: callPDCL, callLOAMPI                               *
      *                                                               *
      * Calls: ZSEDIT                                                 *
      *                                                               *
      *****************************************************************
     C     SrConvAmt     BEGSR
     C                   CALL      'ZSEDIT'
     C                   PARM                    ZFLD15           15 0
     C                   PARM                    ZDECS             1 0
     C                   PARM      *BLANKS       ZECODE            1
     C                   PARM                    ZOUT21           21
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrWrtSynchPD - Write to Synch File LEMQLGPD (PDCL)            *
      *                                                               *
      * Called by: SRPDCLIN                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWrtSynchPD  BEGSR
      *
     C                   CLEAR                   LEMQLGPF
     C                   EVAL      LGSTAT  = 'S'
     C                   EVAL      LGFRNT  = WPDCLSeq
     C                   EVAL      LGAPIN  = PAPIName
     C                   EVAL      LGTGTT  = MQTGTT
     C                   EVAL      LGTGTS  = MQTGTS
     C                   EVAL      LGSRCS  = MQSRCS
     C                   EVAL      LGRDNB  = MQRDNB
     C                   EVAL      LGACTN  = MQACTN
     C                   EVAL      LGORLN  = MQORLN
     C                   EVAL      LGPDPR  = MQPDPR
     C                   EVAL      LGPDIN  = MQPDIN
     C                   EVAL      LGSDAT  = MQSDAT
     C                   EVAL      LGLOAN  = MQLOAN
     C                   EVAL      LGVDAT  = MQVDAT
     C                   EVAL      LGSEQN  = MQSEQN
     C                   EVAL      LGATYP  = 'ST'
     C                   EVAL      LGCNUM  = MQCNUM
     C                   EVAL      LGCURR  = MQCURR
     C                   EVAL      LGAMNT  = MQAMNT
     C                   EVAL      LGLTYP  = MQLTYP
     C                   EVAL      LGSTYP  = MQSTYP
     C                   EVAL      LGCLAS  = MQCLAS
     C                   EVAL      LGCNUM  = YECNUM
     C                   EVAL      LGFACL  = YEFACL
     C                   EVAL      LGORG   = YPORG
     C                   EVAL      LGSEQ   = YESEQ
     C                   EVAL      LGRECI  = YRECI
     C                   EVAL      LGDCT   = YPDCT
      *
     C                   EVAL      LGPGNM  = WPGNM
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      * Timestamp
     C                   EVAL      LGSENT = TimeStamp
     C                   MOVEL     PMsgBuf       LGXMLF
     C                   WRITE     LEMQLGPF
 
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * SrWrtSynchPI - Write to Synch File LEMQLGPD (PI)              *
      *                                                               *
      * Called by: SRPDCLUP                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SrWrtSynchPI  BEGSR
      *
     C                   CLEAR                   LEMQLGPF
     C                   IF        MQLOAN <> *BLANKS
     C                   EVAL      LGSTAT  = 'S'
     C                   ELSE
     C                   EVAL      LGSTAT  = 'H'
     C                   ENDIF
     C                   EVAL      LGFRNT  = WPDCLSeq
     C                   EVAL      LGAPIN  = PAPIName
     C                   EVAL      LGTGTT  = MQTGTT
     C                   EVAL      LGTGTS  = MQTGTS
     C                   EVAL      LGSRCS  = MQSRCS
     C                   EVAL      LGRDNB  = MQRDNB
     C                   EVAL      LGACTN  = MQACTN
     C                   EVAL      LGLOAN  = MQLOAN
     C                   EVAL      LGVDAT  = MQVDAT
     C                   EVAL      LGSEQN  = MQSEQN
     C                   EVAL      LGATYP  = MQATYP
     C                   EVAL      LGCNUM  = MQCNUM
     C                   EVAL      LGCURR  = MQCURR
     C                   EVAL      LGAMNT  = MQAMNT
     C                   EVAL      LGLTYP  = MQLTYP
     C                   EVAL      LGSTYP  = MQSTYP
     C                   EVAL      LGCLAS  = MQCLAS
     C                   EVAL      LGCNUM  = YECNUM
     C                   EVAL      LGFACL  = YEFACL
     C                   EVAL      LGORG   = YPORG
     C                   EVAL      LGSEQ   = YESEQ
     C                   EVAL      LGRECI  = YRECI
     C                   EVAL      LGDCT   = YPDCT
     C                   EVAL      LGORLN  = W@LOAN                                         MD022465
      *
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    TimeStamp
      * Timestamp
     C                   EVAL      LGPGNM  = WPGNM
     C                   EVAL      LGSENT = TimeStamp
     C                   MOVEL     PMsgBuf       LGXMLF
      *
     C                   WRITE     LEMQLGPF
      *
     C                   ENDSR
      *****************************************************************                    MD021423E
     C/EJECT                                                                               MD021423E
      *****************************************************************                    MD021423E
      *                                                               *                    MD021423E
      * SrWrtSynchBSC - Write to Synch File LEMQLGPD (BC/SC)          *                    MD021423E
      *                                                               *                    MD021423E
      * Called by: SRPDCLIN                                           *                    MD021423E
      *                                                               *                    MD021423E
      * Calls: None                                                   *                    MD021423E
      *                                                               *                    MD021423E
      *****************************************************************                    MD021423E
     C     SrWrtSynchBSC BEGSR                                                             MD021423E
      *                                                                                    MD021423E
     C                   CLEAR                   LEMQLGPF                                  MD021423E
      *                                                                                    MD021423E
     C                   EVAL      LGSTAT  = 'S'                                           MD021423E
     C                   EVAL      LGFRNT  = WPDCLSeq                                      MD021423E
     C                   EVAL      LGAPIN  = PAPIName                                      MD021423E
     C                   EVAL      LGTGTT  = MQTGTT                                        MD021423E
     C                   EVAL      LGTGTS  = MQTGTS                                        MD021423E
     C                   EVAL      LGSRCS  = MQSRCS                                        MD021423E
     C                   EVAL      LGRDNB  = MQRDNB                                        MD021423E
     C                   EVAL      LGACTN  = MQACTN                                        MD021423E
     C                   EVAL      LGLOAN  = MQLOAN                                        MD021423E
     C                   EVAL      LGVDAT  = MQVDAT                                        MD021423E
     C                   EVAL      LGSEQN  = MQSEQN                                        MD021423E
     C                   EVAL      LGATYP  = LoamType                                      MD021423E
     C                   EVAL      LGCNUM  = MQCNUM                                        MD021423E
     C                   EVAL      LGCURR  = MQCURR                                        MD021423E
     C**********         EVAL      LGAMNT  = MQAMNT                               MD021423E MD022465
     C                   Z-ADD     0             LGAMNT                                     MD022465
     C                   EVAL      LGORLN  = MQORLN                                         MD022465
     C                   EVAL      LGLTYP  = MQLTYP                                        MD021423E
     C                   EVAL      LGSTYP  = MQSTYP                                        MD021423E
     C                   EVAL      LGCLAS  = MQCLAS                                        MD021423E
     C                   EVAL      LGCNUM  = YECNUM                                        MD021423E
     C                   EVAL      LGFACL  = YEFACL                                        MD021423E
     C                   EVAL      LGORG   = YPORG                                         MD021423E
     C                   EVAL      LGSEQ   = YESEQ                                         MD021423E
     C                   EVAL      LGRECI  = YRECI                                         MD021423E
     C                   EVAL      LGDCT   = YPDCT                                         MD021423E
      *                                                                                    MD021423E
     C                   CALLB     'ZAGENTMSTM'                                            MD021423E
     C                   PARM                    TimeStamp                                 MD021423E
      * Timestamp                                                                          MD021423E
     C                   EVAL      LGPGNM  = WPGNM                                         MD021423E
     C                   EVAL      LGSENT = TimeStamp                                      MD021423E
     C                   MOVEL     PMsgBuf       LGXMLF                                    MD021423E
      *                                                                                    MD021423E
     C                   WRITE     LEMQLGPF                                                MD021423E
      *                                                                                    MD021423E
     C                   ENDSR                                                             MD021423E
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      * ConvertDate - Converts Midas Date to Full Date                *
      *                                                               *
      * Called by: SRPDCLUP                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     ConvertDate   BEGSR
      *
     C                   CALLB     'ZDATE2'
     C                   PARM      PDate         ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM                    ZADATE            7
      *
     C                   MOVEL     *BLANKS       ConvertedDT      30
     C                   MOVEL     ZDATE         DateDS
     C                   MOVEL     '2000'        Year              4
     C                   MOVE      DatYY         Year
      *
     C                   EVAL      ConvertedDT = DatDD + ' ' +
     C                             %TRIM(MONAR(DatMM)) +
     C                             ' ' + Year
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      *
     C     WKLON         KLIST
     C                   KFLD                    WALON             6
     C                   KFLD                    WEPAR             1
      *
                                                                                           MD021423E
      *                                                                                    MD021423E
     C     ACCKEY        KLIST                                                             MD021423E
     C                   KFLD                    WALON             6                       MD021423E
     C                   KFLD                    WEPAR             1                       MD021423E
      *                                                                                    MD021423E
      ** Initializing the LDA information in COB
      *
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPROC = *BLANKS
     C                   EVAL      DBPGM = WIUSR
     C                   OUT       LDA
      *
      ** Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '*MSG    '    @RTCD
     C                   PARM      '*FIRST  '    @OPTN
     C     SDBANK        PARM      SDBANK        DSSDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANK
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 012
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access System Value Details
      *
     C                   EVAL      POP01 = 'MQTransSdrQueueCOB'
     C                   EVAL      POP02 = 'MQJMSRespQueueCOB'
     C                   EVAL      POP03 = 'MQQueueMgrCOB'
     C                   EVAL      POP04 = 'MQPDPUserIDCOB'
     C                   EVAL      POP05 = 'GlobalSystemPrefix'
     C                   EVAL      POP06 = 'PDCLAccSeqNo'
     C                   EVAL      POP07 = 'PDCLRunAsIdentity'
      *
     C                   CALL      'AOSVALR0'
     C                   PARM      *BLANKS       WRETCD
     C                   PARM                    POP01
     C                   PARM      *BLANKS       PVL01
     C                   PARM                    POP02
     C                   PARM      *BLANKS       PVL02
     C                   PARM                    POP03
     C                   PARM      *BLANKS       PVL03
     C                   PARM                    POP04
     C                   PARM      *BLANKS       PVL04
     C                   PARM                    POP05
     C                   PARM      *BLANKS       PVL05
     C                   PARM                    POP06
     C                   PARM      *BLANKS       PVL06
     C                   PARM                    POP07
     C                   PARM      *BLANKS       PVL07
     C                   PARM      *BLANKS       POP08
     C                   PARM      *BLANKS       PVL08
     C                   PARM      *BLANKS       POP09
     C                   PARM      *BLANKS       PVL09
     C                   PARM      *BLANKS       POP10
     C                   PARM      *BLANKS       PVL10
      *
     C                   IF        WRETCD <>  *BLANKS
     C                   MOVEL     'SDSVALPD'    DBFILE
     C                   Z-ADD     013           DBASE                U7U8
     C                   MOVEL     POP01         DBKEY
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   EVAL      PWIPQueue = PVL01
     C                   EVAL      WkRespQ   = PVL02
     C                   EVAL      WkMQMgr   = PVL03
     C                   EVAL      WkUser    = %TRIM(PVL04)
     C                   EVAL      SysPrefix = PVL05
     C                   MOVEL     PVL06         SeqFlg
     C                   MOVEL     PVL07         RunAsIdentity
      *
      * If not Run As Identity no need to supply username and password
     C                   IF        RunAsIdentity = 'N'
     C                   EVAL      PValidList = ValidList
     C                   EVAL      PLibrary = SysPrefix + 'GMLIB'
     C                   EXSR      GetPassWord
     C                   ENDIF
      *
      ** Get Lending ICD
      *
     C                   CALL      'AOCLNDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDCLND        PARM      SDCLND        DSSDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBFILE = 'SDCLNDPD'
     C                   EVAL      DBKEY = '*CALL'
     C                   EVAL      DBASE = 014
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get General Ledger Details
      *
     C                   CALL      'AOGELRR1'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDGELR        PARM      SDGELR        DSSDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 015
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get Modules Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST'      @OPTN
     C     SDMMOD        PARM      SDMMOD        DSSDY
      *
      ** Database Error
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY = @OPTN
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBASE = 016
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** CARs
      *
     C                   MOVE      'N'           CGL058
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CGL058'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CGL058
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE028
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE028'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE028
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE005
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE009
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE009'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE009
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE014
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE014
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE023
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE023'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE023
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE025
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE025'      @SARD
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE025
     C                   ENDIF
      *
     C                   MOVE      'N'           CLE031                                     MD046080
     C                   CALLB     'AOSARDR0'                                               MD046080
     C                   PARM      *BLANKS       @RTCD                                      MD046080
     C                   PARM      '*VERIFY'     @OPTN                                      MD046080
     C                   PARM      'CLE031'      @SARD                                      MD046080
      *                                                                                     MD046080
     C     @RTCD         IFEQ      *BLANKS                                                  MD046080
     C                   MOVE      'Y'           CLE031                                     MD046080
     C                   ENDIF                                                              MD046080
      *                                                                                     MD046080
     C                   Z-ADD     0             I
     C                   MOVE      *OFF          *IN99
      *
      ** First read, store BICN
      *
     C     *LOVAL        SETLL     SDBRCHL5
     C                   READ      SDBRCHL5                               99
      *
     C     *IN99         IFEQ      *ON
      *
      ** DBERR 006
      *
     C                   EVAL      @@RTCD = '*RECUPD'
     C     *LOCK         IN        LDA
     C                   MOVEL     'LEMAPYUPD'   DBPGM
     C                   MOVE      'SDBRCHL5'    DBFILE
     C                   MOVE      *BLANKS       DBKEY
     C                   Z-ADD     017           DBASE
     C                   OUT       LDA
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     *IN99         DOUEQ     *ON
     C                   ADD       1             I
     C                   MOVE      A8BICN        @BIC(I)
     C                   READ      SDBRCHL5                               99
     C                   ENDDO
      *
     C                   ENDIF
     C                   MOVE      *OFF          *IN99
      *                                                                                     MD022465
      ** Full cache SDCURRPD                                                                MD022465
      *                                                                                     MD022465
     C     *LOVAL        SETLL     SDCURRL1                                                 MD022465
     C                   READ      SDCURRL1                                                 MD022465
     C                   DOW       NOT %EOF AND CurrIdx <= %ELEM(CurrCache)                 MD022465
     C                   EVAL      CurrCache(CurrIdx) = A6CYCD                              MD022465
     C                   EVAL      DSCurr(CurrIdx) = SDCURR                                 MD022465
     C                   EVAL      CurrIdx = CurrIdx + 1                                    MD022465
     C                   READ      SDCURRL1                                                 MD022465
     C                   ENDDO                                                              MD022465
     C                   EVAL      TrailIdx = CurrIdx - 1                                   MD022465
      *                                                                                     MD022465
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * GetPassWord - Get password in Validation List                 *
      *                                                               *
      * Called by: callPDCL                                           *
      *                                                               *
      * Calls: SRFmtWMsg                                              *
      *                                                               *
      *****************************************************************
     C     GetPassWord   BEGSR
      *
     C                   CALL      'UT000033'
     C                   PARM      '*BLANKS'     PRtnCode
     C                   PARM      'F'           PAction
     C                   PARM                    PValidList
     C                   PARM                    PLibrary
     C                   PARM      WkUser        PUserName
     C                   PARM      *BLANKS       PPassword1
     C                   PARM      *BLANKS       PPassword2
     C                   PARM      *BLANKS       PDescrptn
      *
     C                   IF        PRtnCode <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C                   EVAL      DBKEY  = WkUser
     C                   EVAL      DBFILE = 'GPLDAPVL'
     C                   EVAL      DBASE = 018
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * @DEFN - Definition subroutine.                                *
      *                                                               *
      *****************************************************************
     C     @DEFN         BEGSR
      *
      ** Input.
      *
     C     *ENTRY        PLIST
     C                   PARM                    WRETCD
     C                   PARM                    W@TYPE
     C                   PARM                    W@LOAN
     C                   PARM                    W@FSEQ
     C                   PARM                    W@FCOD
     C                   PARM                    W@FACL
     C                   PARM                    W@FBRCP
     C                   PARM                    W@CNU2
     C                   PARM                    W@EDATYP
     C                   PARM                    W@PDAMT
     C                   PARM                    W@INT
     C                   PARM                    W@AV
     C                   PARM                    W@ORIGP
     C                   PARM                    W@ORIGI
     C                   PARM                    W@LASN
     C                   PARM                    W@AVDAT
     C                   PARM                    W@DCLTYP
     C                   PARM                    WSCCY                                     MD049745A
     C                   PARM                    WSIND                                     MD049745A
     C                   PARM                    WSRATE                                    MD049745A
      *
      ** Output.
      *
     C                   PARM                    W@OPDAM
     C                   PARM                    W@OPDINT
      *
      ** Original transaction Reporting/Basel II date.
      *
     C                   PARM                    WYPLNR
     C                   PARM                    WPGNM
     C                   PARM                    BlockCredit                               MD021423E
      *
      ** Keys.
      *
     C     KFEE          KLIST
     C                   KFLD                    WFECU
     C                   KFLD                    WFCTY
     C                   KFLD                    WFLNO
     C                   KFLD                    WFSEQ
      *
     C     KFCLT         KLIST
     C                   KFLD                    WFCUS
     C                   KFLD                    WFTYP
     C                   KFLD                    WFSEQ
     C                   KFLD                    WRCDT1
      *
     C     KFCAM         KLIST
     C                   KFLD                    WFCUS
     C                   KFLD                    WFTYP
     C                   KFLD                    WFSEQ
      *
     C     WLOLNK        KLIST
     C                   KFLD                    WRECI
     C                   KFLD                    W@LOAN
     C                   KFLD                    WPIIN
      *
     C     WFELNK        KLIST
     C                   KFLD                    W@CNU2
     C                   KFLD                    W@FACL
     C                   KFLD                    W@LOAN
     C                   KFLD                    W@FSEQ
     C                   KFLD                    WRECI
      *
     C     KLAKEY        KLIST
     C                   KFLD                    WKLNR
     C                   KFLD                    WKVDT
     C                   KFLD                    WKLSN
      *
     C     KLOAM         KLIST
     C                   KFLD                    WPLON
     C                   KFLD                    WSDAT
      *
     C     WFELNK2       KLIST
     C                   KFLD                    W@LOAN
     C                   KFLD                    W@CNU2
     C                   KFLD                    W@FACL5A
     C                   KFLD                    W@FSEQ2A
      *
     C     LEMQLGK1      KLIST
     C                   KFLD                    WSTAT
     C                   KFLD                    WPGNM
 
     C     KLOAM2        KLIST
     C                   KFLD                    W#LON
     C                   KFLD                    W#DAT
                                                                                            MD022465
     C     K_MQLG        KLIST                                                              MD022465
     C                   KFLD                    W@LOAN                                     MD022465
     C                   KFLD                    W#ATYP                                     MD022465
                                                                                            MD022465
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR - Error handling                                        *
      *                                                               *
      * Called by: Automatically called by the program                *
      *                                                               *
      * Calls: *None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
     C                   IF        runBefore <> 'Y'
     C                   EVAL      runBefore = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      WRETCD = '*ERROR*'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDeftCLIP - Build/Prepare the transaction data and           *
      *              format to XML.                                   *
      *                                                               *
      *              This is for the CLIP message                     *
      *                                                               *
      * Called by: SRPDCLIN                                           *
      *                                                               *
      * Calls: SRFmtWMsg                                              *
      *                                                               *
      *****************************************************************
     C     SRDeftCLIP    BEGSR
      *
     C                   MOVE      'Y'           RATESPFL          1
     C                   MOVE      'N'           BCODEFLG                                   MD031225
      *
     C                   EVAL      PMode    = '*CLEAR'
     C                   EXSR      SRFmtWMsg
      *
      ** XML Header  (Start)
      *
     C                   EVAL      PMode    = '*ENTER'
     C                   EVAL      PAPIName = 'WRITE!MIDAS.CLIP'
     C                   EVAL      PFormat  = 'CLIP'
      *
     C                   EVAL      PFldTag  = 'APTGTTYPE'
     C                   EVAL      PFldData = 'CLIP'
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      MQTGTT = 'CLIP - Loan'
     C                   WHEN      RecordType = FeeLoan
     C                   EVAL      MQTGTT = 'CLIP - Loan Fees'
     C                   WHEN      RecordType = FeeFacility
     C                   EVAL      MQTGTT = 'CLIP - Facility Fees'
     C                   ENDSL
      *
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APTGTSYS'
     C                   EVAL      PFldData = 'MIDAS'
     C                   EVAL      MQTGTS = 'MIDAS'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APSRCSYS'
     C                   EVAL      PFldData = 'MIDASCOB'
     C                   EVAL      MQSRCS = 'MIDASCOB'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APFOTRANID'
     C                   EVAL      PFldData = WPDCLSeq
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APRPRLOCN'
     C                   EVAL      PFldData = 'B'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APRPYQUEUE'
     C                   EVAL      PFldData = WkRespQ
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   IF        RunAsIdentity = 'N'
 
     C                   EVAL      PFldTag  = 'APUSERID'
     C                   EVAL      PFldData = WkUser
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   EVAL      PFldTag  = 'APPASSWORD'
     C                   EVAL      PFldData = PPassword1
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   ENDIF
      *
      ** Front Office ID
     C                   EVAL      PFldTag  = 'DDFRNT'
     C                   EVAL      PFldData = WPDCLSeq
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** +--- XML (CLIP details) -----------------------------------------+
      **                                                                  *
      **   Statement below will facilitate building of CLIP-XML           *
      **   transactions to be sent to MQ for processing                   *
      **                                                                  *
      ** +----------------------------------------------------------------+
      *
      ** Action Code
     C                   EVAL      PFldTag  = 'DDACTN'
     C                   EVAL      PFldData = 'I'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                    MK022807B
      ** Loan Number                                                                       MK022807B
     C                   EVAL      PFldTag  = 'DDLNRF'                                     MK022807B
     C                   EVAL      PFldData = @@PDCL                                       MK022807B
     C                   EVAL      PFldType = *BLANK                                       MK022807B
     C                   EVAL      PFldAttr = *BLANK                                       MK022807B
     C                   EXSR      SRFmtWMsg                                               MK022807B
      *
      ** Customer
     C                   EVAL      PFldTag  = 'DDCUST'
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        ProcessingType = PartsPurchase                          MK021423A
     C                   EVAL      PFldData = C_OLNO                                       MK021423A
     C                   ELSE                                                              MK021423A
     C                   EVAL      PFldData = C_CNUM
     C                   ENDIF                                                             MK021423A
     C                   OTHER
     C                   EVAL      PFldData = E_FECNUM
     C                   ENDSL
      *
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                    MK021423A
      ** Purchased from customer                                                           MK021423A
     C                   EVAL      PFldTag  = 'DDPFRM'                                     MK021423A
      *                                                                                    MK021423A
     C                   SELECT                                                            MK021423A
     C                   WHEN      RecordType = Loan                                       MK021423A
     C                   IF        ProcessingType = PartsPurchase                          MK021423A
     C                   EVAL      PFldData = C_CNUM                                       MK021423A
     C                   ELSE                                                              MK021423A
     C                   EVAL      PFldData = *BLANKS                                      MK021423A
     C                   ENDIF                                                             MK021423A
     C                   OTHER                                                             MK021423A
     C                   EVAL      PFldData = *BLANKS                                      MK021423A
     C                   ENDSL                                                             MK021423A
      *                                                                                    MK021423A
     C                   EVAL      PFldType = *BLANK                                       MK021423A
     C                   EVAL      PFldAttr = *BLANK                                       MK021423A
     C                   EXSR      SRFmtWMsg                                               MK021423A
      *
      ** Facility Customer
     C                   EVAL      PFldTag  = 'DDFCUS'
      *
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   EVAL      PFldData = E_FECNUM
     C                   OTHER
     C                   EVAL      PFldData = C_FCUS
     C                   ENDSL
      *
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Facility Type
     C                   EVAL      PFldTag  = 'DDFTYP'
      *
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   MOVEL     E_FEFACL      FTYPX             3
     C                   MOVE      E_FEFACL      FSEQX             2
     C                   OTHER
     C                   MOVEL     C_FTYP        FTYPX
     C                   MOVE      C_FSEQ        FSEQX
     C                   ENDSL
      *
     C                   EVAL      PFldData = FTYPX
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Facility sequence
     C                   EVAL      PFldTag  = 'DDFSEQ'
     C                   EVAL      PFldData = FSEQX
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Branch
     C                   EVAL      PFldTag  = 'DDBRCA'
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      PFldData = C_BRCA
     C                   OTHER
     C                   EVAL      PFldData = E_FEBRCA
     C                   ENDSL
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Loan Type
     C                   SELECT
     C                   WHEN      RecordType = Loan
      *
     C                   IF        WPIIN = 'P'
     C                   EVAL      PFldData = AYPPLT
     C                   ELSE
     C                   EVAL      PFldData = AYIPLT
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      PFldData = AUCLTY
      *
     C                   ENDSL
 
     C                   MOVEL     PFldData      MQLTYP
     C                   EVAL      PFldTag  = 'DDLTYP'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Sub Type
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
      *
     C                   IF        WPIIN = 'P'
     C                   EVAL      PFldData = AYPPLS
     C                   ELSE
     C                   EVAL      PFldData = AYIPLS
     C                   ENDIF
      *
     C                   OTHER
     C                   EVAL      PFldData = AUCLST
      *
     C                   ENDSL
 
     C                   MOVEL     PFldData      MQSTYP
     C                   EVAL      PFldTag  = 'DDSUTP'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Loan class
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WPIIN = 'P'
     C                   EVAL      PFldData = AYPPLC
     C                   ELSE
     C                   EVAL      PFldData = AYIPLC
     C                   ENDIF
     C                   OTHER
     C                   EVAL      PFldData = AUCLCL
     C                   ENDSL
      *
     C                   MOVEL     PFldData      MQCLAS
     C                   EVAL      PFldTag  = 'DDCLAS'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** OLNO
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      PFldData = C_OLNO
     C                   OTHER
     C                   EVAL      PFldData = *BLANKS
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDOLNO'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Mirror Loan Number
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   EVAL      PFldData = *BLANKS
     C                   OTHER
     C                   EVAL      PFldData = C_MLNR
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDMLNR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Currency
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      @CURR = C_CCY
     C                   OTHER
     C                   EVAL      @CURR = E_FEFCCY
     C                   ENDSL
     C                   EVAL      PFldData = @CURR
     C                   MOVEL     @CURR         MQCURR
      *
     C                   EVAL      PFldTag  = 'DDCURR'
     C                   EVAL      PFldData = @CURR
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Current Principal Amount
     C                   IF        @CURR <> *BLANKS                                         MD022465
     C                   EXSR      SrChkCurr
     C                   ENDIF                                                              MD022465
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WCPAM <> 0
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WCPAM                                          MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      WCPAM = WOUTAMT                                         MD049745A
     C                   ENDIF                                                             MD049745A
     C                   MOVEL     WCPAM         ZFLD15
     C                   EVAL      MQPDPR = WCPAM
     C                   EVAL      MQPDIN = 0
     C                   EVAL      MQAMNT = WCPAM
     C                   ELSE
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WINT                                           MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      WINT = WOUTAMT                                          MD049745A
     C                   ENDIF                                                             MD049745A
     C                   MOVEL     WINT          ZFLD15
     C                   EVAL      MQPDPR = 0
     C                   EVAL      MQPDIN = WINT
     C                   EVAL      MQAMNT = WINT
     C                   ENDIF
     C                   OTHER
     C                   IF        CLE031 = 'Y'                                            MD049745A
     C                   EVAL      WINAMT = WCPAM                                          MD049745A
     C                   EVAL      WCCY2 = @CURR                                           MD049745A
     C                   EXSR      SrConvert                                               MD049745A
     C                   EVAL      WCPAM = WOUTAMT                                         MD049745A
     C                   ENDIF                                                             MD049745A
     C                   MOVEL     WCPAM         ZFLD15
     C                   EVAL      MQPDIN = 0
     C                   EVAL      MQPDPR = WCPAM
     C                   EVAL      MQAMNT = WCPAM
     C                   ENDSL
      *
     C                   EXSR      SrConvAmt
     C                   EVAL      PFldData = %TRIM(ZOUT21)
     C                   EVAL      PFldTag  = 'DDCPAM'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Deal Date
     C**********         MOVE      BJRDNB        PDate             5 0                     MD021423E
      *                                                                                    MD021423E
     C                   SELECT                                                            MD021423E
      *                                                                                    MD021423E
      ** Loan PDCL - Deal Date should be the deal date of the original loans               MD021423E
     C                   WHEN      RecordType = Loan                                       MD021423E
     C                   MOVEL     C_DDAT        PDate             5 0                     MD021423E
      *                                                                                    MD021423E
      ** Fee PDCL - Deal Date should be the start date of the fee                          MD021423E
     C                   OTHER                                                             MD021423E
     C                   MOVEL     E_FEPSTD      PDate                                     MD021423E
     C                   ENDSL                                                             MD021423E
      *                                                                                    MD021423E
     C                   IF        PDate > BJRDNB                                          MD022807E
     C                   EVAL      PDate = BJRDNB                                          MD022807E
     C                   ENDIF                                                             MD022807E
      *                                                                                    MD022807E
     C                   EXSR      ConvertDate
     C                   EVAL      PFldTag  = 'DDDDAT'
     C                   MOVEL     ConvertedDT   PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   MOVEL     ZDATE         MQSDAT
      *
      ** Auto-settle indicator
     C                   EVAL      PFldTag  = 'DDAUTO'
     C                   EVAL      PFldData = 'C'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Value Date
     C**********         MOVE      BJRDNB        PDate                                     MD022807H
     C**********         IF        RecordType = FeeLoan OR                       MD022807E MD022807H
     C**********                   RecordType = FeeFacility                      MD022807E MD022807H
     C**********         IF        PDate <  E_FEPSTD                             MD022807E MD022807H
     C**********         EVAL      PDate = E_FEPSTD                              MD022807E MD022807H
     C**********         ENDIF                                                   MD022807E MD022807H
     C**********         ENDIF                                                   MD022807E MD022807H
      *                                                                                    MD022807E
     C                   MOVE      W@AVDAT       PDate                                     MD022807H
     C                   EXSR      ConvertDate
     C                   EVAL      PFldTag  = 'DDVDAT'
     C                   MOVEL     ConvertedDT   PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   MOVEL     ZDATE         MQVDAT
      *
      ** Automatic Pay at Maturity
     C                   EVAL      PFldTag  = 'DDAPMI'
     C                   EVAL      PFldData = 'Y'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
                                                                                            MD049078
     C                   EVAL      PFldTag  = 'DDSTAL'                                      MD049078
     C                   EVAL      PFldData = C_STAL                                        MD049078
     C                   EVAL      PFldType = *BLANK                                        MD049078
     C                   EVAL      PFldAttr = *BLANK                                        MD049078
     C                   EXSR      SRFmtWMsg                                                MD049078
      *
      ** Linked to Syndicate
     C                   EVAL      PFldTag  = 'DDLNKS'
     C                   EVAL      PFldData = 'N'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Assignment/ Participant
     C                   IF        RecordType = Loan
     C                   EVAL      PFldTag  = 'DDASSN'
     C                   EVAL      PFldData = C_GASS
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDIF
      *
      ** Facility currency
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   EVAL      PFldData = M_FCCY
     C                   OTHER
     C                   EVAL      PFldData = C_FCCY
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDFCCY'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** PNTF
     C                   EVAL      PFldTag  = 'DDPNTF'
     C                   EVAL      PFldData = 'N'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** FPTF
     C                   EVAL      PFldTag  = 'DDFPTF'
     C                   EVAL      PFldData = 'N'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Initial Start Date
     C**********         MOVE      BJRDNB        PDate                                      MD031225
     C                   MOVE      W@AVDAT       PDate                                      MD031225
     C                   EXSR      ConvertDate
     C                   EVAL      PFldTag  = 'DDISDT'
     C                   MOVEL     ConvertedDT   PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Base Rate Code
     C                   MOVEL     '0'           CHINF             1
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVE      *BLANKS       PFldData                                   MD031851
     C                   EXSR      SRGetRates
     C                   IF        WPIIN = 'P'
     C                   IF        wPBSR <> 0
     C                   MOVEL     wPBSR         PBSR              2
     C                   EVAL      PFldData  = PBSR
     C                   MOVEL     '1'           CHINF
     C                   MOVE      'N'           RATESPFL          1
     C                   MOVE      'Y'           BCODEFLG          1                        MD031225
     C                   ENDIF
     C                   ELSEIF    WPIIN = 'I'
     C                   IF        wIBSR <> 0
     C                   MOVEL     wIBSR         IBSR              2
     C                   EVAL      PFldData  = IBSR
     C                   MOVEL     '1'           CHINF
     C                   MOVE      'N'           RATESPFL          1
     C                   MOVE      'Y'           BCODEFLG                                   MD031225
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C**********         MOVEL     AUCBSR        PFldData                                   MD031851
     C                   IF        AUCBSR <> 0                                              MD031225
     C                   MOVEL     AUCBSR        PFldData                                   MD031851
     C                   MOVE      'Y'           BCODEFLG                                   MD031225
     C                   MOVE      'N'           RATESPFL                                   MD031851
     C                   ELSE                                                               MD031851
     C                   MOVE      *BLANKS       PFldData                                   MD031851
     C                   ENDIF                                                              MD031225
     C**********         MOVE      'N'           RATESPFL          1                        MD031851
     C                   ENDSL
      *
     C                   EVAL      PFldTag  = 'DDBRTT'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Change indicator
     C                   MOVEL     *BLANKS       PFldData
     C                   IF        CHINF = '1'
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_CHIN        PFldData
     C                   OTHER
     C                   MOVEL     AUCRIN        PFldData
     C                   ENDSL
      *
     C                   EVAL      PFldTag  = 'DDCHIN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDIF
      *
      ** Current rate spread
      ** Spread rate should be available only if Base Rate Code or                          MD031225
      ** Current Base Rate is available.                                                    MD031225
      *                                                                                     MD031225
     C                   SELECT                                                             MD031225
     C                   WHEN      RecordType = Loan                                        MD031225
     C                   IF        WPIIN = 'P'                                              MD031225
     C                   IF        wPBRT <> 0                                               MD031225
     C                   MOVE      'N'           RATESPFL                                   MD031225
     C                   ENDIF                                                              MD031225
     C                   ELSE                                                               MD031225
     C                   IF        wIBRT <> 0                                               MD031225
     C                   MOVE      'N'           RATESPFL                                   MD031225
     C                   ENDIF                                                              MD031225
     C                   ENDIF                                                              MD031225
     C                   OTHER                                                              MD031225
     C                   IF        AUCBRT <> 0                                              MD031225
     C                   MOVE      'N'           RATESPFL                                   MD031225
     C                   ENDIF                                                              MD031225
     C                   ENDSL                                                              MD031225
      *                                                                                     MD031225
     C                   MOVE      *BLANKS       ZFIELD                                     MD031225
     C**********         IF        RATESPFL = 'N'                                  MD031225 MD031851
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WPIIN = 'P'
     C                   IF        wPRSP <> 0
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      wPRSP         ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF
     C                   ELSEIF    WPIIN = 'I'
     C                   IF        wIRSP <> 0
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      wIRSP         ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   IF        AUCRSP <> 0                                              MD031851
     C                   MOVE      AUCRSP        ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF                                                              MD031851
     C                   ENDSL
     C**********         ENDIF                                                     MD031225 MD031851
      *                                                                                     MD031225
     C                   IF        RATESPFL = 'N'                                           MD031851
     C                   EVAL      PFldData  = ZFIELD
     C                   ELSE                                                               MD031851
     C                   EVAL      PFldData = *BLANKS                                       MD031851
     C                   ENDIF                                                              MD031851
     C                   MOVEL     ZFIELD        RTSPX            16
 
     C                   EVAL      PFldTag  = 'DDRTSP'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Spread indicator
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WPIIN = 'P'
     C                   IF        wPRSI <> *BLANKS
     C                   MOVEL     wPRSI         PFldData
     C                   ENDIF
     C                   ELSE
     C                   IF        wIRSI <> *BLANKS
     C                   MOVEL     wIRSI         PFldData
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   MOVEL     AUCRIN        PFldData
     C                   ENDSL
      *
     C                   EVAL      PFldTag  = 'DDSPIN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Calculation Basis
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WPIIN = 'P'
     C                   IF        wPICB <> *BLANKS
     C                   MOVEL     wPICB         PFldData
     C                   ENDIF
     C                   ELSEIF    WPIIN = 'I'
     C                   IF        wIICB <> *BLANKS
     C                   MOVEL     wIICB         PFldData
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   MOVEL     AUICBS        PFldData
     C                   ENDSL
      *
     C                   EVAL      PFldTag  = 'DDCALC'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Total interest
     C                   MOVEL     '*'           PFldData
     C                   EVAL      PFldTag  = 'DDIPRD'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      ** Margin
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C     C_MARG        IFLT      *ZEROS
     C                   MOVEL     'Y'           DDNEGV            1
     C                   Z-SUB     C_MARG        C_MARG
     C                   ELSE
     C                   MOVEL     *BLANKS       DDNEGV
     C                   ENDIF
      *
     C                   MOVE      *BLANKS       ZFIELD           16
     C                   MOVE      C_MARG        ZFIELD
     C                   Z-ADD     5             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   MOVEL     ZFIELD        PFldData
 
     C                   EVAL      PFldTag  = 'DDMARG'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** NEGV
     C                   MOVEL     DDNEGV        PFldData
     C                   EVAL      PFldTag  = 'DDNEGV'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Interest captilisation indicator
     C                   MOVEL     'N'           PFldData
     C                   EVAL      PFldTag  = 'DDINTC'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Round Down Interest Indicator
     C                   MOVEL     C_RDFC        PFldData
     C                   EVAL      PFldTag  = 'DDRDFC'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Additional Day Indicator
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_ADDI        PFldData
     C                   OTHER
     C                   IF        BKALDI = 'Y'
     C                   MOVEL     'L'           PFldData
     C                   ELSE
     C                   MOVEL     'F'           PFldData
     C                   ENDIF
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDADDI'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Repayment type
     C                   MOVE      2             REPTX             1
     C                   MOVEL     REPTX         PFldData
     C                   EVAL      PFldTag  = 'DDREPT'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Billing/Telex indicator
     C                   MOVEL     *BLANKS       SDCLIN            1
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   MOVEL     'N'           BTIN
     C                   OTHER
     C                   IF        AYLNPT = 66 OR
     C                             AYLNPT = 67 OR
     C                             AYLNPT = 69 OR
     C                             AYLNPT = 72
     C                   MOVEL     *BLANKS       BTIN              1
     C                   MOVEL     'Y'           SDCLIN
     C                   ELSE
     C                   MOVEL     BPBTIN        BTIN
     C                   ENDIF
     C                   ENDSL
      *
     C                   MOVEL     BTIN          PFldData
     C                   EVAL      PFldTag  = 'DDBTIN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Billing days
     C                   IF        SDCLIN = 'Y'
     C                   MOVEL     BPDBDY        PFldData
     C                   EVAL      PFldTag  = 'DDBLDY'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDIF
      *
      ** Payment Due Day Indicator
     C                   MOVEL     'M'           PFldData
     C                   EVAL      PFldTag  = 'DDPDDI'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Payment Taken Due Indicator
     C                   MOVEL     'M'           PFldData
     C                   EVAL      PFldTag  = 'DDPTDI'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Add on Interest Flag
     C                   MOVEL     'N'           PFldData
     C                   EVAL      PFldTag  = 'DDADIF'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Add on Charges Flag
     C                   MOVEL     'N'           PFldData
     C                   EVAL      PFldTag  = 'DDADCF'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Include Charges in Interest Flag
     C                   MOVEL     'N'           PFldData
     C                   EVAL      PFldTag  = 'DDICIF'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Current Base Rate
      ** It should only available if Base Rate Code is not available.                       MD031225
      *                                                                                     MD031225
     C                   MOVE      *BLANKS       ZFIELD                                     MD031225
     C                   IF         BCODEFLG = 'N'                                          MD031225
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        WPIIN = 'P'
     C                   IF        wPBRT <> 0
     C                   MOVE      'N'           RATESPFL                                   MD031225
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      wPBRT         ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF
     C                   ELSE
     C                   IF        wIBRT <> 0
     C                   MOVE      'N'           RATESPFL          1                        MD031225
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      wIBRT         ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   IF        AUCBRT <> 0                                              MD031225
     C                   MOVE      'N'           RATESPFL                                   MD031225
     C**********         ENDIF                                                     MD031225 MD031851
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      AUCBRT        ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   ENDIF                                                              MD031851
     C                   ENDSL
     C                   ENDIF                                                              MD031225
 
     C                   EVAL      PFldData  = ZFIELD
     C                   EVAL      PFldTag  = 'DDBASR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   IF        RATESPFL = 'Y'
     C                   EVAL      PFldData  = RTSPX
     C                   EVAL      PFldTag  = 'DDFXRT'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDIF
      *
      ** Account officer
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_ACOF        PFldData
     C                   OTHER
     C                   MOVEL     E_FEACOF      PFldData
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDACOF'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Local industry code
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        C_LIND <> 0
     C                   MOVE      C_LIND        LINDX             3
     C                   ENDIF
     C                   OTHER
     C                   IF        BBLICD <> *BLANKS
     C                   MOVE      BBLICD        LINDX
     C                   ENDIF
     C                   ENDSL
 
     C                   MOVEL     LINDX         PFldData
     C                   EVAL      PFldTag  = 'DDLIND'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Indicators: secured/doc/fees
     C                   EVAL      PFldData = 'N'                                           MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   TESTB     '2'           C_RELI                   97
     C                   IF        *IN97 = *ON
     C**********         MOVEL     C_RELI        PFldData                                   MD022640
     C                   EVAL      PFldData = 'Y'                                           MD022640
     C                   ENDIF
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDFEEI'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Originating branch
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVE      C_ORBR        ORBR              3
     C                   WHEN      RecordType = FeeFacility
     C                   IF        CGL058 = 'Y' AND BGMBIN = 'Y'
     C                             AND BKOBRU = 'Y'
     C                   MOVEL     BBBRCD        ORBR
     C                   ELSE
     C**********         MOVEL     *BLANKS       ORBR                                       MD023442
     C                   MOVEL     E_FEBRCA      ORBR                                       MD023442
     C                   ENDIF
     C                   WHEN      RecordType = FeeLoan
     C                   IF        CGL058 = 'Y' AND BGMBIN = 'Y'
     C                             AND BKOBRU = 'Y'
     C                   MOVEL     BBBRCD        ORBR
     C                   ELSE
     C**********         MOVEL     C_ORBR        ORBR                                       MD022640
     C                   MOVEL     E_FEBRCA      ORBR                                       MD022640
     C                   ENDIF
     C                   ENDSL
 
     C                   MOVEL     ORBR          PFldData
     C                   EVAL      PFldTag  = 'DDORBR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Country of Risk
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_CRSK        PFldData
     C                   OTHER
     C                   MOVEL     M_CRSK        PFldData
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDCRSK'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Book Code
     C                   SELECT
     C**********         WHEN      RecordType = Loan                                        MD022640
     C                   WHEN      RecordType = Loan or RecordType = FeeLoan                MD022640
     C                   MOVEL     C_BOKC        PFldData
     C                   OTHER
     C                   MOVEL     BPDBKC        PFldData
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDBOKC'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Indicators: secured/doc/fees
     C                   EVAL      PFldData = 'N'                                           MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   TESTB     '1'           C_RELI                   97
     C                   IF        *IN97 = *ON
     C                   MOVEL     'Y'           PFldData
     C                   ENDIF                                                              MD022640
     C                   ENDSL                                                              MD022640
     C**********         EVAL      PFldTag  = 'DDSECI'                                      MD022640
     C                   EVAL      PFldTag  = 'DDDOCI'                                      MD022640
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C**********         ENDIF                                                              MD022640
     C**********         ENDSL                                                              MD022640
     C                   EVAL      PFldData = 'N'                                           MD022640
     C                   SELECT                                                             MD022640
     C                   WHEN      RecordType = Loan                                        MD022640
     C                   TESTB     '0'           C_RELI                   97                MD022640
     C                   IF        *IN97 = *ON                                              MD022640
     C                   MOVEL     'Y'           PFldData                                   MD022640
     C                   ENDIF                                                              MD022640
     C                   ENDSL                                                              MD022640
     C                   EVAL      PFldTag  = 'DDSECI'                                      MD022640
     C                   EVAL      PFldType = *BLANK                                        MD022640
     C                   EVAL      PFldAttr = *BLANK                                        MD022640
     C                   EXSR      SRFmtWMsg                                                MD022640
      *
      ** Facility sequence number
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        SeqFlg  = 'Y'
     C                   MOVE      C_FSEQ        SEQX              2
     C                   ELSE
     C                   MOVE      C_LASQ        SEQX
     C                   ENDIF
     C                   OTHER
     C                   IF        SeqFlg  = 'Y'
     C                   IF        RecordType = FeeFacility                                 MD025112
     C                   MOVE      E_FEFACL      SEQX
     C                   ELSE                                                               MD025112
     C                   MOVE      C_FSEQ        SEQX                                       MD025112
     C                   ENDIF                                                              MD025112
     C                   ELSE
     C                   SELECT                                                            MD021423D
     C                   WHEN      RecordType = FeeLoan                                    MD021423D
     C                   MOVE      C_LASQ        SEQX                                      MD021423D
     C                   OTHER                                                             MD021423D
     C                   MOVE      *BLANKS       SEQX
     C                   ENDSL                                                             MD021423D
     C                   ENDIF
     C                   ENDSL
 
     C**********         MOVEL     FSEQX         PFldData                                  MD021423D
     C                   MOVEL     SEQX          PFldData                                  MD021423D
     C                   EVAL      PFldTag  = 'DDACSQ'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Portfolio reference
     C                   SELECT
     C                   WHEN      NOT(RecordType = FeeFacility)
     C                   MOVEL     C_PTFR        PFldData
     C                   EVAL      PFldTag  = 'DDPTFR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Name and address code
     C                   MOVEL     'B'           PFldData
     C                   EVAL      PFldTag  = 'DDNACD'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      **  Narrative 1
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      PFldData = TXT01 + W@LOAN
     C                   OTHER
     C                   SELECT                                                             MD022640
     C                   WHEN      RecordType = FeeLoan                                     MD022640
     C                   MOVEL     E_FEFSEQ      FSEQX                                      MD022640
     C                   EVAL      PFldData = TXT02  + E_FECNUM + '-'                       MD022640
     C                             + W@LOAN + '-' + FSEQX                                   MD022640
     C                   OTHER                                                              MD022640
     C                   MOVEL     E_FEFACL      FACLX             5
     C                   MOVEL     E_FEFSEQ      FSEQX             2
     C                   EVAL      PFldData = TXT02  + E_FECNUM + '-'
     C                             + FACLX + '-' + FSEQX
     C                   ENDSL                                                              MD022640
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDNAR1'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Base currency exchange rate
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      A6SPRT        ZFIELD           16
     C                   Z-ADD     8             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   EVAL      PFldData  = ZFIELD
     C                   EVAL      PFldTag  = 'DDBCXR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                     MD022640
      ** Base rate muliply divide indicator                                                 MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData  = A6MDIN                                       MD022640
     C                   EVAL      PFldTag  = 'DDBMIN'                                      MD022640
     C                   EVAL      PFldType = *BLANK                                        MD022640
     C                   EVAL      PFldAttr = *BLANK                                        MD022640
     C                   EXSR      SRFmtWMsg                                                MD022640
      *
      ** Facility ccy exch. rate
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVE      C_FCXR        ZFIELD           16
     C                   OTHER
     C                   MOVE      A6SPRT        ZFIELD
     C                   ENDSL
     C                   Z-ADD     8             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   EVAL      PFldData  = ZFIELD
     C                   EVAL      PFldTag  = 'DDFCXR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      **  FMDI
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_FMDI        PFldData
     C                   OTHER
     C                   IF        M_FCCY <> BJCYCD AND
     C                             A6MDIN = 'M'
     C                   MOVEL     'D'           PFldData
     C                   ELSEIF    M_FCCY <> BJCYCD AND
     C                             A6MDIN = 'D'
     C                   MOVEL     'M'           PFldData
     C                   ELSEIF    M_FCCY =  BJCYCD
     C                   MOVEL     A6MDIN        PFldData
     C                   ENDIF
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDFMIN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receiver of the Guarantee
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RECE        PFldData
     C                   EVAL      PFldTag  = 'DDRECE'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Customer Confirmation
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_COCU        PFldData
     C                   EVAL      PFldTag  = 'DDCOCU'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Funding Spread/Rate
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_FSRP        PFldData
     C                   EVAL      PFldTag  = 'DDFSRP'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Funding Sign
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_FSGN        PFldData
     C                   EVAL      PFldTag  = 'DDFSGN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Funding Profit Centre
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_FPRC        PFldData
     C                   OTHER
     C                   MOVEL     E_FEPRFC      PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDFPRC'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   SELECT
     C                   WHEN      RecordType = Loan
      *
      ** Special instructions - 1
     C                   MOVEL     K_SPI1        PFldData
     C                   EVAL      PFldTag  = 'DDSPI1'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Special instructions - 2
     C                   MOVEL     K_SPI2        PFldData
     C                   EVAL      PFldTag  = 'DDSPI2'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Special instructions - 3
     C                   MOVEL     K_SPI3        PFldData
     C                   EVAL      PFldTag  = 'DDSPI3'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** FUTN
     C                   SELECT
     C                   WHEN      RecordType = FeeFacility
     C                   MOVEL     M_PCRF        PFldData
     C                   OTHER
     C                   IF        AYLNPT = 66 OR
     C                             AYLNPT = 67 OR
     C                             AYLNPT = 69 OR
     C                             AYLNPT = 72
     C                   ELSE
     C                   MOVEL     M_PCRF        PFldData
     C                   ENDIF
     C                   ENDSL
 
     C                   EVAL      PFldTag  = 'DDFUTN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Multi-ccy Rollover Allowed
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_MCRA        PFldData
     C                   EVAL      PFldTag  = 'DDMCRA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** PC Transaction Reference
     C                   SELECT
     C                   WHEN      RecordType = FeeLoan
     C                   EVAL      PFldData = C_PCRF
     C                   EVAL      PFldTag  = 'DDLUTN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      PFldTag  = 'DDSUTN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Multi-ccy Rollover Allowed
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      PFldData = C_MCRA
     C                   EVAL      PFldTag  = 'DDLUTN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
     C                   ENDSL
      *
      ** Receiver number
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RVNO        PFldData
     C                   OTHER
     C                   MOVEL     M_RVNO        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDRVNO'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Cover Message Required
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_CVMR        PFldData
     C                   OTHER
     C                   MOVEL     M_CVMR        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDCVMR'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                    MD021423E
     C                   SELECT                                                            MD021423E
     C                   WHEN      BlockCredit = 'N'                                       MD021423E
      *                                                                                    MD021423E
      ** Pay - settlement method                                                           MD021423E
     C                   SELECT                                                            MD021423E
     C                   WHEN      RecordType = Loan                                       MD021423E
     C                   MOVE      C_RSTM        PSTMX             2                       MD021423E
     C                   OTHER                                                             MD021423E
     C                   MOVE      E_RSTM        PSTMX                                     MD021423E
     C                   ENDSL                                                             MD021423E
     C                   MOVEL     PSTMX         PFldData                                  MD021423E
     C                   EVAL      PFldTag  = 'DDPSTM'                                     MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
      *                                                                                    MD021423E
      ** PONS                                                                              MD021423E
     C                   SELECT                                                            MD021423E
     C                   WHEN      RecordType = Loan                                       MD021423E
     C                   IF        C_RSTM = 05                                             MD021423E
     C                   SELECT                                                            MD021423E
     C                   WHEN      ProcessingType = PartsSold                              MD021423E
     C                   EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_RONS)                MD021423E
     C                   OTHER                                                             MD021423E
     C                   EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_RONS)                MD021423E
     C                   ENDSL                                                             MD021423E
     C                   ELSE                                                              MD021423E
     C                   MOVEL     C_RONS        PFldData                                  MD021423E
     C                   ENDIF                                                             MD021423E
     C                   OTHER                                                             MD021423E
     C                   IF        E_RSTM = 05                                             MD021423E
     C                   EVAL      PFldData = %TRIM(E_OSDB) + %TRIM(E_RONS)                MD021423E
     C                   ELSE                                                              MD021423E
     C                   MOVEL     E_RONS        PFldData                                  MD021423E
     C                   ENDIF                                                             MD021423E
     C                   ENDSL                                                             MD021423E
     C                   EVAL      PFldTag  = 'DDPONX'                                     MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   EVAL      MQACTN = *BLANKS                                        MD021423E
      *                                                                                    MD021423E
     C                   OTHER                                                             MD021423E
     C                   EVAL      MQACTN = 'W'                                            MD021423E
     C                   MOVEL     '00'          PFldData                                  MD021423E
     C                   EVAL      PFldTag  = 'DDPSTM'                                     MD021423E
     C                   EVAL      PFldType = *BLANK                                       MD021423E
     C                   EVAL      PFldAttr = *BLANK                                       MD021423E
     C                   EXSR      SRFmtWMsg                                               MD021423E
     C                   ENDSL                                                             MD021423E
      *                                                                                     MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
      ** Pay Settlement currency details                                                    MD046080
     C                   EVAL      PFldTag  = 'DDPSCY'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   EVAL      PFldData = C_SCCY                                        MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   EVAL      PFldData = E_FESCCY                                      MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   EVAL      PFldData = E_FESCCY                                      MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
      *                                                                                     MD046080
     C                   EVAL      PFldTag  = 'DDPEXR'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   MOVEL     C_REXR        PFldData                                   MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   MOVEL     E_FEREXR      PFldData                                   MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   MOVEL     E_FEREXR      PFldData                                   MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
      *                                                                                     MD046080
     C                   EVAL      PFldTag  = 'DDPEXI'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   EVAL      PFldData = C_REXI                                        MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   EVAL      PFldData = E_FEREXI                                      MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   EVAL      PFldData = E_FEREXI                                      MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
     C                   ENDIF                                                              MD046080
      ** Pay - ordering customer number
      ** IF PMTX is not 01 07 or 08 value must be blank.                                    MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        PSTMX = '01' or PSTMX = '07' or PSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_POCN        PFldData
     C                   OTHER
     C                   MOVEL     M_POCN        PFldData
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDPOCN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Pay - ordering bank number
      ** IF PMTX is not 01 07 or 08 value must be blank.                                    MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        PSTMX = '01' or PSTMX = '07' or PSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_POBN        PFldData
     C                   OTHER
     C                   MOVEL     M_POBN        PFldData
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDPOBN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receiver correspondent number
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RCRN        PFldData
     C                   OTHER
     C                   MOVEL     M_RCRN        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDRCRN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receiver correspondent a/c line
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RCRA        PFldData
     C                   OTHER
     C                   MOVEL     M_RCRA        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDRCRA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Pay - intermediary bank number
      ** IF PMTX is not 01 07 or 08 value must be blank.                                    MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        PSTMX = '01' or PSTMX = '07' or PSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_PIBN        PFldData
     C                   OTHER
     C                   MOVEL     M_PIBN        PFldData
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDPIBN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** pay - intermediary bank a/c line
      ** IF PMTX is not 01 07 or 08 value must be blank.                                    MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        PSTMX = '01' or PSTMX = '07' or PSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_PIBA        PFldData
     C                   OTHER
     C                   MOVEL     M_PIBA        PFldData
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDPIBA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** A/C with bank no
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_AWBN        PFldData
     C                   OTHER
     C                   MOVEL     M_AWBN        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDAWBN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** A/C with bank a/c line
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_AWBA        PFldData
     C                   OTHER
     C                   MOVEL     M_AWBA        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDAWBA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Beneficiary number
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BENN        PFldData
     C                   OTHER
     C                   MOVEL     M_BENN        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBENN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Beneficiary a/c line
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BENA        PFldData
     C                   OTHER
     C                   MOVEL     M_BENA        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBENA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Details of Pay 1
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_DTP1        PFldData
     C                   OTHER
     C                   MOVEL     M_DTP1        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDDTP1'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Details of Pay 2
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_DTP2        PFldData
     C                   OTHER
     C                   MOVEL     M_DTP2        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDDTP2'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Details of Pay 3
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_DTP3        PFldData
     C                   OTHER
     C                   MOVEL     M_DTP3        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDDTP3'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Details of Pay 4
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_DTP4        PFldData
     C                   OTHER
     C                   MOVEL     M_DTP4        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDDTP4'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** IN Currency in Fld 72
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_ICCY        PFldData
     C                   OTHER
     C                   MOVEL     E_FEICCY      PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDIC72'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 1
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB1        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB1        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB1'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 2
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB2        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB2        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB2'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 3
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB3        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB3        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB3'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 4
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB4        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB4        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB4'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 5
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB5        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB5        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB5'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Bank to bank info 6
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_BTB6        PFldData
     C                   OTHER
     C                   MOVEL     M_BTB6        PFldData
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDBTB6'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receipt - settlement method
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVE      C_RSTM        RSTMX             2
     C                   OTHER
     C                   MOVE      E_RSTM        RSTMX
     C                   ENDSL
     C                   MOVEL     RSTMX         PFldData
     C                   EVAL      PFldTag  = 'DDRSTM'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** RONS
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        C_RSTM = 05
     C                   SELECT
     C                   WHEN      ProcessingType = PartsSold
     C                   EVAL      PFldData = %TRIM(C_OSDB) + %TRIM(C_RONS)
     C                   OTHER
     C                   EVAL      PFldData = %TRIM(C_OMDB) + %TRIM(C_RONS)
     C                   ENDSL
     C                   ELSE
     C                   MOVEL     C_RONS        PFldData
     C                   ENDIF
     C                   OTHER
     C                   IF        E_RSTM = 05
     C                   EVAL      PFldData = %TRIM(E_OSDB) + %TRIM(E_RONS)
     C                   ELSE
     C                   MOVEL     E_RONS        PFldData
     C                   ENDIF
     C                   ENDSL
     C                   EVAL      PFldTag  = 'DDRONX'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *                                                                                     MD046080
      ** Pay Settlement currency details                                                    MD046080
     C                   IF        CLE031 = 'Y'                                             MD046080
     C                   EVAL      PFldTag  = 'DDRSCY'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   EVAL      PFldData = C_SCCY                                        MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   EVAL      PFldData = E_FESCCY                                      MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   EVAL      PFldData = E_FESCCY                                      MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
      *                                                                                     MD046080
     C                   EVAL      PFldTag  = 'DDREXR'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   MOVEL     C_REXR        PFldData                                   MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   MOVEL     E_FEREXR      PFldData                                   MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   MOVEL     E_FEREXR      PFldData                                   MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
      *                                                                                     MD046080
     C                   EVAL      PFldTag  = 'DDREXI'                                      MD046080
     C                   SELECT                                                             MD046080
     C                   WHEN      RecordType = Loan                                        MD046080
     C                   EVAL      PFldData = C_REXI                                        MD046080
     C                   WHEN      RecordType = FeeLoan                                     MD046080
     C                   EVAL      PFldData = E_FEREXI                                      MD046080
     C                   WHEN      RecordType = FeeFacility                                 MD046080
     C                   EVAL      PFldData = E_FEREXI                                      MD046080
     C                   ENDSL                                                              MD046080
     C                   EVAL      PFldType = *BLANK                                        MD046080
     C                   EVAL      PFldAttr = *BLANK                                        MD046080
     C                   EXSR      SRFmtWMsg                                                MD046080
     C                   ENDIF                                                              MD046080
      *
      ** Receipt - intermediary bank number
      ** IF settlement is not 01 07 or 08 value must be blank.                              MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        RSTMX = '01' or RSTMX = '07' or RSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RIBN        PFldData
     C                   OTHER
     C**********         MOVEL     M_RIBN        PFldData                                   MD022640
     C                   MOVEL     E_RIBN        PFldData                                   MD022640
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDRIBN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receipt - intermediary bank A/C
      ** IF settlement is not 01 07 or 08 value must be blank.                              MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        RSTMX = '01' or RSTMX = '07' or RSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_RIBA        PFldData
     C                   OTHER
     C**********         MOVEL     M_RIBA        PFldData                                   MD022640
     C                   MOVEL     E_RIBA        PFldData                                   MD022640
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDRIBA'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receipt - ordering bank no
      ** IF settlement is not 01 07 or 08 value must be blank.                              MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        RSTMX = '01' or RSTMX = '07' or RSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_ROBN        PFldData
     C                   OTHER
     C**********         MOVEL     M_ROBN        PFldData                                   MD022640
     C                   MOVEL     E_ROBN        PFldData                                   MD022640
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDROBN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Receipt - ordering customer number
      ** IF settlement is not 01 07 or 08 value must be blank.                              MD022640
      *                                                                                     MD022640
     C                   EVAL      PFldData = *BLANK                                        MD022640
     C                   IF        RSTMX = '01' or RSTMX = '07' or RSTMX = '08'             MD022640
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   MOVEL     C_ROCN        PFldData
     C                   OTHER
     C**********         MOVEL     M_ROCN        PFldData                                   MD022640
     C                   MOVEL     E_ROCN        PFldData                                   MD022640
     C                   ENDSL
     C                   ENDIF                                                              MD022640
     C                   EVAL      PFldTag  = 'DDROCN'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Contractual details
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   IF        ExistLEPRAT = *ON
     C                   IF        WPIIN = 'P'
      *
     C                   IF        B2PCSP <> 0
     C                   EVAL      wPCSP = B2PCSP
     C                   EVAL      wPCSG = B2PCSG
     C                   EVAL      wPFMT = B2PFMT
     C                   EVAL      wPRFD = B2PRFD
     C                   ELSE
     C                   EVAL      wPCSP = AYPCSP
     C                   EVAL      wPCSG = AYPCSG
     C                   EVAL      wPFMT = AYPFMT
     C                   EVAL      wPRFD = AYPRFD
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   IF        B2ICSP <> 0
     C                   EVAL      wPCSP = B2ICSP
     C                   EVAL      wPCSG = B2ICSG
     C                   EVAL      wPFMT = B2IFMT
     C                   EVAL      wPRFD = B2IRFD
     C                   ELSE
     C                   EVAL      wPCSP = AIPCSP
     C                   EVAL      wPCSG = AIPCSG
     C                   EVAL      wPFMT = AIPFMT
     C                   EVAL      wPRFD = AIPRFD
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
     C                   OTHER
     C                   EVAL      wPCSP = AUPCSP
     C                   EVAL      wPCSG = AUPCSG
     C                   EVAL      wPFMT = AUPFMT
     C                   EVAL      wPRFD = AUPRFD
     C                   ENDSL
      *
      ** Past Due Default Contractual spread
     C                   MOVEL     *BLANKS       ZFIELD           16
     C                   MOVE      wPCSP         ZFIELD           16
     C                   Z-ADD     7             ZDEC              1 0
     C                   CALL      'ZEDIT'
     C                   PARM                    ZFIELD
     C                   PARM                    ZDEC
     C                   EVAL      PFldData  = ZFIELD
 
     C                   EVAL      PFldTag  = 'DDCNSP'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Past Due Default Contractual Spread Indicator
     C                   MOVEL     wPCSG         PFldData
     C                   EVAL      PFldTag  = 'DDCNSG'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Past Due Default Rounding Method
     C                   MOVEL     wPFMT         PFldData
     C                   EVAL      PFldTag  = 'DDRDMT'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Past Due Default Rounding Fraction/Decimal
     C                   MOVEL     wPRFD         PFldData
     C                   EVAL      PFldTag  = 'DDRDFD'
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Original Loan Number
      *
     C                   SELECT
     C                   WHEN      RecordType = Loan
     C                   EVAL      PFldTag  = 'DDORLN'
     C                   MOVEL     W@LOAN        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
     C                   OTHER
      *
      ** Origin Facility Customer
      *
     C                   EVAL      PFldTag  = 'DDOFCU'
     C                   MOVEL     W@CNU2        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Origin Facility Sequence
      *
     C**********         EVAL      PFldTag  = 'DDOFCU'                                     MD021423E
     C                   EVAL      PFldTag  = 'DDOFAC'                                     MD021423E
     C                   MOVEL     W@FACL        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Origin Fee Code
      *
     C                   EVAL      PFldTag  = 'DDOFES'
     C                   MOVEL     W@FCOD        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Origin Fee Sequence
      *
     C                   EVAL      PFldTag  = 'DDOFSQ'
     C                   MOVEL     W@FSEQ        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
      *
      ** Origin Fee Loan
      *
     C                   EVAL      PFldTag  = 'DDOFLN'
     C                   MOVEL     W@LOAN        PFldData
     C                   EVAL      PFldType = *BLANK
     C                   EVAL      PFldAttr = *BLANK
     C                   EXSR      SRFmtWMsg
 
     C                   EVAL      MQCNUM = W@CNU2                                         MD022807I
     C**********         ENDSL                                                             MD022807I
 
     C                   EVAL      MQCNUM = W@CNU2
     C                   IF        W@FACL <> 0
     C                   MOVEL     W@FACL        MQORLN
     C                   ENDIF
     C                   ENDSL                                                             MD022807I
 
     C                   EVAL      PFldTag  = 'AUTH'                                       MD021423B
     C                   EVAL      PFldData = 'Y'                                          MD021423B
     C                   EVAL      PFldType = *BLANK                                       MD021423B
     C                   EVAL      PFldAttr = *BLANK                                       MD021423B
     C                   EXSR      SRFmtWMsg                                               MD021423B
                                                                                           MD021423B
     C                   EVAL      PMode    = '*RETURN'
     C                   EXSR      SRFmtWMsg
 
     C                   MOVEL     W@LOAN        MQORLN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrGetRates - Get PDCL Default rates                           *
      *                                                               *
      * Called by: SRDeftCLIP                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRGetRates    BEGSR
      *
      ** Access default penalty rates table first to check if override
      ** exist on loan level
      *
     C     W@LOAN        CHAIN     LEPRATL1
     C                   IF        %FOUND(LEPRATL1)
      *
     C                   IF        (B2PBSR <> 0) OR
     C                             (B2PBRT <> 0) OR
     C                             (B2PRSP <> 0) OR
     C                             (B2PRAT <> *BLANKS)
     C                   EVAL      wPBSR  = B2PBSR
     C                   EVAL      wPBRT  = B2PBRT
     C                   EVAL      wPRSP  = B2PRSP
     C                   EVAL      wPRSI  = B2PRAT
     C                   MOVE      B2PICB        wPICB
     C                   ELSE
      *
      ** Defaul Rates from Loan Type subtype table
      ** which was previously accessed in SRLOAN subroutine
      *
     C                   EVAL      wPBSR  = AYPBSR
     C                   EVAL      wPBRT  = AYPBRT
     C                   EVAL      wPRSP  = AYPRSP
     C                   EVAL      wPRSI  = AYPRSI
     C                   MOVE      AYPICB        wPICB
     C                   ENDIF
      *
     C                   IF        (B2IBSR <> 0) OR
     C                             (B2IBRT <> 0) OR
     C                             (B2IRSP <> 0) OR
     C                             (B2IRAT <> *BLANKS)
     C                   EVAL      wIBSR  = B2IBSR
     C                   EVAL      wIBRT  = B2IBRT
     C                   EVAL      wIRSP  = B2IRSP
     C                   EVAL      wIRSI  = B2IRAT
     C                   MOVEL     B2IICB        wIICB
     C                   ELSE
      *
      ** Defaul Rates from Loan Type subtype table
      ** which was previously accessed in SRLOAN subroutine
      *
     C                   EVAL      wIBSR  = AYIBSR
     C                   EVAL      wIBRT  = AYIBRT
     C                   EVAL      wIRSP  = AYIRSP
     C                   EVAL      wIRSI  = AYIRSI
     C                   MOVEL     AYIICB        wIICB
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Defaul Rates from Loan Type subtype table
      ** which was previously accessed in SRLOAN subroutine
      *
     C                   EVAL      wPBSR  = AYPBSR
     C                   EVAL      wPBRT  = AYPBRT
     C                   EVAL      wPRSP  = AYPRSP
     C                   EVAL      wPRSI  = AYPRSI
     C                   MOVE      AYPICB        wPICB
     C                   EVAL      wIBSR  = AYIBSR
     C                   EVAL      wIBRT  = AYIBRT
     C                   EVAL      wIRSP  = AYIRSP
     C                   EVAL      wIRSI  = AYIRSI
     C                   MOVEL     AYIICB        wIICB
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRGetLTST - Get Loan Type Sub Type                           *
      *                                                               *
      *****************************************************************
     C     SRGetLTST     BEGSR
      *
      ** Find type/subtype info
      *
     C                   CALL      'AOLOANR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      wLTYP         PLoanType
     C                   PARM      wSUTP         PLSubType
     C                   PARM      wCLAS         PLClass
     C     SDLOAN        PARM      SDLOAN        DSFDY
      *
     C                   IF        @RTCD <> *BLANKS
     C                   EVAL      WRETCD = '*ERROR'
     C     wLTYP         CAT       wSUTP         DBKEY
     C                   MOVE      wCLAS         DBKEY
     C                   EVAL      DBFILE = 'SDLOANPD'
     C                   EVAL      DBASE = 019
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                               MD021423E
      *****************************************************************                    MD021423E
      *                                                               *                    MD022807B
      * SrGetLoan - Get next available loan number                    *                    MD022807B
      *                                                               *                    MD022807B
      *              This is for the CLIP message                     *                    MD022807B
      *                                                               *                    MD022807B
      * Called by: SRPDCLIN                                           *                    MD022807B
      *                                                               *                    MD022807B
      * Calls: AOLENOU0                                               *                    MD022807B
      *                                                               *                    MD022807B
      *****************************************************************                    MD022807B
     C     SRGetLoan     BEGSR                                                             MD022807B
      *                                                               *                    MD022807B
     C                   CALL      'AOLENOU0'                                              MD022807B
     C                   PARM      *BLANKS       @RTCD                                     MD022807B
     C                   PARM      '*KEY'        @OPTN                                     MD022807B
     C                   PARM      AYRANG        @PRANG                                    MD022807B
     C     SDLENO        PARM      SDLENO        DSFDY                                     MD022807B
     C     @RTCD         IFNE      *BLANKS                                                 MD022807B
     C                   EVAL      WRETCD = '*ERROR'                                       MD022807B
     C                   MOVE (P)  @PRANG        DBKEY                                     MD022807B
     C                   EVAL      DBFILE = 'SDLENOPD'                                     MD022807B
     C                   EVAL      DBASE = 091                                             MD022807B
     C                   EXSR      *PSSR                                                   MD022807B
     C                   ENDIF                                                             MD022807B
      *                                                                                    MD022807B
     C                   ENDSR                                                             MD022807B
      *****************************************************************                    MD022807B
      /EJECT                                                                               MD022807B
      *****************************************************************                    MD022807B
      *                                                               *                     MD023203
      * SrResetSeq - Reset PDCL Transaction Sequence Number           *                     MD023203
      *                                                               *                     MD023203
      *****************************************************************                     MD023203
     C     SrResetSeq    BEGSR                                                              MD023203
     C                   IF        WBJRDNB <> PRUND                                         MD023203
     C                   MOVEL     '0000000'     PDCLTS                                     MD023203
     C                   MOVEL     WBJRDNB       PRUND                                      MD023203
     C                   OUT       LEPDCL                                                   MD023203
     C     *LOCK         IN        LEPDCL                                                   MD023203
     C                   MOVE      PDCLTS        WPDCLTS                                    MD023203
     C                   ENDIF                                                              MD023203
     C                   ENDSR                                                              MD023203
      *****************************************************************                     MD023203
      /EJECT                                                                                MD023203
      *****************************************************************                     MD023203
      *****************************************************************                    MD049745A
      *                                                               *                    MD049745A
      * SrConvert - Convert Currency                                  *                    MD049745A
      *                                                               *                    MD049745A
      *****************************************************************                    MD049745A
                                                                                           MD049745A
     C     SrConvert     BEGSR                                                             MD049745A
                                                                                           MD049745A
     C                   EVAL      WCCY1 = WSCCY                                           MD049745A
     C                   IF        WSIND = 'M'                                             MD049745A
     C                   EVAL      WMDIN = 'D'                                             MD049745A
     C                   ELSE                                                              MD049745A
     C                   EVAL      WMDIN = 'M'                                             MD049745A
     C                   ENDIF                                                             MD049745A
     C                   IF        WREV = 'Y'                                              MD049745A
     C                   IF        WMDIN = 'M'                                             MD049745A
     C                   EVAL      WMDIN = 'D'                                             MD049745A
     C                   ELSE                                                              MD049745A
     C                   EVAL      WMDIN = 'M'                                             MD049745A
     C                   ENDIF                                                             MD049745A
     C                   ENDIF                                                             MD049745A
                                                                                           MD049745A
      ** If one of currencies is blank, skip conversion                                    MD049745A
                                                                                           MD049745A
     C                   IF        WCCY1 = *BLANKS or WCCY2 = *BLANKS                      MD049745A
     C                   EVAL      WOUTAMT = WINAMT                                        MD049745A
     C                   ELSE                                                              MD049745A
                                                                                           MD049745A
      ** From currency                                                                     MD049745A
                                                                                           MD049745A
     C                   CALLB     'AOCURRR0'                                              MD049745A
     C                   PARM      *BLANK        @RTCD                                     MD049745A
     C                   PARM      '*KEY   '     @OPTN                                     MD049745A
     C                   PARM                    WCCY1                                     MD049745A
     C     SDCURR        PARM      SDCURR        DSSDY                                     MD049745A
                                                                                           MD049745A
      ** Save necessary details                                                            MD049745A
                                                                                           MD049745A
     C                   EVAL      WSPRT1 = A6SPRT                                         MD049745A
     C                   EVAL      WMDIN1 = A6MDIN                                         MD049745A
     C                   EVAL      WNBDP1 = A6NBDP                                         MD049745A
      ** To currency                                                                       MD049745A
                                                                                           MD049745A
     C                   CALLB     'AOCURRR0'                                              MD049745A
     C                   PARM      *BLANK        @RTCD                                     MD049745A
     C                   PARM      '*KEY   '     @OPTN                                     MD049745A
     C                   PARM                    WCCY2                                     MD049745A
     C     SDCURR        PARM      SDCURR        DSSDY                                     MD049745A
                                                                                           MD049745A
      ** Save necessary details                                                            MD049745A
                                                                                           MD049745A
     C                   EVAL      WSPRT2 = A6SPRT                                         MD049745A
     C                   EVAL      WMDIN2 = A6MDIN                                         MD049745A
     C                   EVAL      WNBDP2 = A6NBDP                                         MD049745A
                                                                                           MD049745A
      ** Convert amount                                                                    MD049745A
                                                                                           MD049745A
     C                   CALL      'ZCONVZ1'                                               MD049745A
     C                   PARM                    WINAMT                                    MD049745A
     C                   PARM                    WSRATE                                    MD049745A
     C                   PARM                    WMDIN                                     MD049745A
     C                   PARM                    WCCY1                                     MD049745A
     C                   PARM                    WCCY2                                     MD049745A
     C                   PARM                    WNBDP1                                    MD049745A
     C                   PARM                    WNBDP2                                    MD049745A
     C                   PARM                    WOUTAMT                                   MD049745A
                                                                                           MD049745A
     C                   ENDIF                                                             MD049745A
                                                                                           MD049745A
     C                   ENDSR                                                             MD049745A
                                                                                           MD049745A
      *****************************************************************                    MD049745A
      /EJECT                                                                               MD049745A
      *****************************************************************                    MD049745A
**  CPY@
(c) Finastra International Limited 2013
**  POWR -- USED IN CURRENCY CONVERSION(FACILITY)
0000001
0000010
0000100
0001000
0010000
0100000
1000000
**  MONAR - Months Arrary
January
February
March
April
May
June
July
August
September
October
November
December
