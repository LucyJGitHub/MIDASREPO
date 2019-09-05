     H DEBUG FIXNBR(*INPUTPACKED)
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Lending PC interface')                        *
/*E*I****FIXNBR(*ZONED)************************************************                       174621
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2010M - Lending PC Interface                               *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  This program will be submitted automatically during          *
      *  Input Cycle Initiation and ended automatically by Input      *
      *  Cycle Termination. It will process all messages sent from    *
      *  the Lending PC application for an individual branch as units *
      *  of work calling the appropriate Midas update program in      *
      *  'batch' mode.                                                *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  LEC2010A - Lending PC Interface Control                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *                                                               *
      *  Last Amend No. MD041126           Date 27Aug19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 262992             Date 01Aug12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CER059             Date 19Jul10               *
      *                 CER047             Date 19May08               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CAS016             Date 28Feb06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027A            Date 10May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 227708             Date 27May04               *
      *                 CLE038             Date 11May04               *
      *                 226033             Date 24Mar04               *
      *                 223592             Date 05Dec03               *
      *                 CLE035             Date 22Sep03               *
      *                 CLE036             Date 22Sep03               *
      *                 CSC023             Date 28Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP074             Date 12May03               *
      *                 219608             Date 23Jul03               *
      *                 CLE034             Date 05May03               *
      *                 209692             Date 19Mar03               *
      *                 CLE031             Date 10Feb03               *
      *                 CAS005             Date 16Dec02               *
      *                 196224             Date 18Sep02               *
      *                 183967             Date 09Sep02               *
      *                 CLE028             Date 27Jun02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 211959             Date 09Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CPK015             Date 22May02               *
      *                 CAP065             Date 07Feb02               *
      *                 202546             Date 31Jan02               *
      *                 202396             Date 21Jan02               *
      *                 202393             Date 21Jan02               *
      *                 CAP053             Date 21Jan02               *
      *                 CAP061             Date 21Jan02               *
      *                 CAP062             Date 21Jan02               *
      *                 CAP063             Date 21Jan02               *
      *                 CAP064             Date 21Jan02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CLE011             Date 07Nov00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CRT004             DATE 04May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 174621             Date 03Feb00               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CEU030             Date 08Jun99               *
      *                 160096             Date 04May99               *
      *                 156295             Date 14APR99               *
      *                 157911 (157911)    Date 03Jun98               *
      *                 157907 (BT1400)    Date 02Feb99               *
      *                 157286 (BT0888)    Date 17Mar99               *
      *                 157217 (BT1420)    Date 29Jan99               *
      *                 CLE008             Date 10Dec98               *
      *                 155873             Date 23Feb99               *
      *                 152356             Date 13Jan99               *
      *                 150876             Date 15Dec98               *
      *                 149199             Date 01Dec98               *
      *                 148191             Date 19Nov98               *
      *                 147902             Date 17Nov98               *
      *                 147261             Date 27Jan99               *
      *                 146971             Date 12Nov98               *
      *                 144096             Date 30Oct98               *
      *                 143802             Date 23Oct98               *
      *                 143614             Date 25Sep98               *
      *                 142225             Date 18Feb99               *
      *                 134390             Date 10Feb99               *
      *                 133783             Date 09Feb99              *
      *                 133237             Date 07Apr98               *
      *                 132762             Date 05Feb99               *
      *                 CEU004             Date 02Feb98               *
      *                 131256             Date 09Mar98               *
      *                 130237             Date 09Feb98               *
      *                 129467             Date 26Jan98               *
      *                 CLE005             Date 22May97               *
      *                 124001             Date 07Oct97               *
      *                 123335             Date 01Oct97               *
      *                 122665             Date 05SEP97               *
      *                 122102             Date 28Aug97               *
      *                 121855             Date 14AUG97               *
      *                 121783             Date 14AUG97               *
      *                 121548             Date 07AUG97               *
      *                 120459             Date 11JUL97               *
      *                 120278             Date 08JUL97               *
      *                 120134             Date 07JUL97               *
      *                 CLE004             Date 07MAY97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD054096.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  262992 - P2: CLE134 API Invalid length of RIDT and BIDT      *
      *           CLE134 / SWIFT                                      *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period) -Recompile.                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027A - Conversion Of Customer Number to Alpha             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                 n*
      *  227708 - If do a reverse of a loan with settlement allocation*
      *           immediately after another transaction with          *
      *           settlement allocations, the timestamp field can     *
      *           still be set to the previous transaction.           *
      *  CLE038 - Lending Enhancement for Nordea: Allocation by Amount*
      *  226033 - Allow for reversals of past dues from Loan Manager  *
      *  223592 - Add flag to show if loan message is part of a       *
      *           principal transfer unit of work. (recompile)        *
      *  CLE035 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Income Splits                                       *
      *  CLE036 - Lending Enhancements for Nordea Phase 1 Priority 2: *
      *           Allow specific base rates (Recompile)               *
      *  CSC023 - SBMJOB output queue must be *JOBD.                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP074 - Lending API enhancements - Loans input.             *
      *  219608 - Amendment of Settlement Allocations needs a 'Before'*
      *           image to ensure the right allocations are reversed. *
      *           Clear LESTALPD after each unit of work is completed.*
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *  209692 - Ensure that new transactions always have a unique   *
      *           PCRF (PC reference) by checking LF/LEPCRFL0         *
      *  CLE031 - Lending Enhancements.                               *
      *           (Recompile).                                        *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *           (Recompile)                                         *
      *  196224 - Remove 183967 (previous fix) as replaced by change  *
      *           to LE2040                                          *
      *  183967 - When loan amendment is sent from PC with a blank    *
      *           loan number Midas reports an error message.
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  211959 - LE2010M would only compile with QMQM in the library *
      *           list. Changed /copies to specify the library name.  *
      *  CPK015 - Packaging changes:                                  *
      *           Recompile over changed LEO1MFPD/LEN1MFPD            *
      *  CAP065 - Override needed for LEIFACLX if LE2020 called via   *
      *         - this program.                                       *
      *  202546 - Override needed for LEFCAMSQ if LE2150 called via   *
      *         - this program (see 190017 - fix for when called      *
      *         - from menu)                                          *
      *  202396 - Work facility number field is only set if a facilty *
      *         - is processed first.                                 *
      *  202393 - Correlation Id processing not relevant if messages  *
      *         - not sent from Loan manager so process all as first  *
      *         - message.                                            *
      *  CAP053 - Override needed for LEILONLX if LE2030 called via   *
      *         - this program.                                       *
      *  CAP061 - Override needed for LEILAMLX if LE2040 called via   *
      *         - this program.                                       *
      *  CAP062 - Override needed for LEIROLLX if LE2070 called via   *
      *         - this program.                                       *
      *  CAP063 - Override needed for LEIMRPLX if LE2110 called via   *
      *         - this program.                                       *
      *  CAP064 - Override needed for LEIFEELX if LE2210 called via   *
      *         - this program.                                       *
      *  CLE011 - Rate Fixing Days for Lending Rollover Processing    *
      *  CRT004 - Cashier Midas TCP/IP interface.                     *
      *             Recompiled over SDBRCHPD Changes                  *
      *  174621 - FIXNBR(*ZONED) now incorporated into RPGBASEMOD     *
      *           creation parameter                                  *
      *  CEU030 - EMU Loan Manager Enhancements (Recompile Only)      *
      *  160096 - Include Funding/Risk participant flag for use in    *
      *           determining Sale of Loan number for syndicated risk *
      *           participations sold.                                *
      *  156295 - Assign correct sale of loan number for risk parts   *
      *           sold against guarantee loans.                       *
      *  157907 - The Funding participant fac seq no needs to be      *
      *           retained when a facility amendment is attached      *
      *           to it                                               *
      *  157286 - Recompile over changed LEF3MFPD file                *
      *  157217 - New "generated by assignment" field for facility    *
      *           amendments (LEA5MFPD) - RECOMPILE(BT1420)           *
      *  CLE008 - Switchable Feature For Loan Administrator Id        *
      *           Recompiled due to changes in LEF1MFPD               *
      *  155873 - Amend confirmations job to run only when there      *
      *           has been a transaction.                             *
      *  152356 - Suppress completion message being sent to MOPERQ    *
      *           for submitted job LEC0212A.                         *
      *  150876 - The check on when to submit the confirmation job    *
      *           does not take account of this job accessing the     *
      *           system clock before and after midnight.             *
      *  149199 - Override share(*no) required on lefeedl1 prior to   *
      *           call to le2210.                                     *
      *  148191 - Wrong mirror loan number being passed on an IPP if  *
      *           facility amended from non-syndicated to syndicated. *
      *  147902 - Loan number required on Manual Repayment for        *
      *           backvalued loan.                                    *
      *  147261 - Add Assignment/Participation indicator (Recompiled) *
      *  146971 - Risk participations for Agented syndicate s/b       *
      *           against IPP.                                        *
      *  144096 - For principal transfers save correct sequence from  *
      *           the 'PT' record to be written to the 'PF' record.   *
      *  143802 - Recompiled due to changes in LEA1MFPD and LEM1MFPD  *
      *  143614 - Need to cope with a direct amendment of a           *
      *           participant facility on Loan Manager.               *
      *  142225 - Changed to submit confirmations job more frequently *
      *           as otherwise SWIFT messages are delayed.            *
      *  134390 - Share(*no) required to call to LE2210 & LE2023      *
      *  133783 - QMQM message unclear                                *
      *  133237 - Recompile over changed LEF3MFPD file                *
      *  132762 - The Funding participant fac seq no needs to be      *
      *           retained when fees are attached to it.              *
      *  CEU004 - LE Settlement Ccy conversion Upgrade to DBA R2.0    *
      *           (RECOMPILED)                                        *
      *  131256 - Add confirmation processing to generate swift       *
      *           messages in batch mode.                             *
      *  130237 - Recompile over changed LEF1MFPD.                    *
      *  129467 - Sequence number returned as zero to Loan Manager    *
      *           as field is not defined in message format file.     *
      *  CLE005 - Customer Lending Enhancements - Others (T3)         *
      *         - Changed to ILE module                               *
      *  124001 - Include original loan number for an IPP.            *
      *  123335 - Recompiled over changed LEO1MFPD.                   *
      *  122665 - LEX9997 issued but no dump                          *
      *  122102 - Correct parameter and reply message processing      *
      *           for window program.                                 *
      *  121855 - Share(*no) required because of call to window pgm.  *
      *  121783 - Call new access objected (AOBRCHR1) created for     *
      *           T1/2 Lending.                                       *
      *  121548 - Correct message not returned for Manual Repayments. *
      *           Also wrong program names in literal.                *
      *  120459 - For part sold, sale of loan number should be from   *
      *           the first message in the unit of work.              *
      *  120278 - Wrong parameter set prior to call to le2030         *
      *  120134 - Wrong parameter set prior to call to le2040         *
      *  CLE004 - Created for Customer Lending Enhancements           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *           F U N C T I O N   O F  I N D I C A T O R S          *
      *                                                               *
      *  30 - Control text 'Reason Code' on Printer File              *
      *----------------------------------------------------------------
      *  U7 U8 LR                                                     *
      ******************************************************************
      *
      **  Mandatory Windows by message type file
     FSDMREFL2  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Optional Windows by message type file
     FSDOREFL2  IF   E           K DISK    INFSR(*PSSR)
      *
      **  Lending Branch Messages work file
     FLEBRMSPD  IF A E             DISK    INFSR(*PSSR)
     F                                     USROPN
      *
      **  PC Interface Audit Report
     FLE2010AU  O    E             PRINTER INFDS(SPOOLU)
     F                                     USROPN
      * Copyright
     D CPY@            S             80    DIM(1) CTDATA PERRCD(1)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      *                                                                                       146971
     D SDLOAN        E DS                  EXTNAME(SDLOANPD)                                  146971
      *
      **  Facilities Transmitted Message format
     D F1MFPD        E DS                  EXTNAME(LEF1MFPD)
      *
      **  Facilities Returned Message format
     D F2MFPD        E DS                  EXTNAME(LEF2MFPD)
      *
      **  Risk Participants/Assignment Transmitted Message format
     D R1MFPD        E DS                  EXTNAME(LER1MFPD)
     D R1MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D R1MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Risk Participants/Assignment Returned Message format
     D R2MFPD        E DS                  EXTNAME(LER2MFPD)
      *
      **  Loans/Participations Purchased/Participations Sold
     D/COPY WNCPYSRC,LE2010MD01
     D N1MFPD        E DS                  EXTNAME(LEN1MFPD)
     D N1MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D N1MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
     D/COPY WNCPYSRC,LE2010MD02
      *
      **  Loans/Participations Purchased/Participations Sold
     D N2MFPD        E DS                  EXTNAME(LEN2MFPD)
      *
      **  Loan Amendments Transmitted Message format
     D A1MFPD        E DS                  EXTNAME(LEA1MFPD)
     D A1MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D A1MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Loan Amendments Returned Message format
     D A2MFPD        E DS                  EXTNAME(LEA2MFPD)
      *
      **  'LAPT' Returned Message format
     D A3MFPD        E DS                  EXTNAME(LEA3MFPD)
      *
      **  'LAPF' Returned Message format
     D A4MFPD        E DS                  EXTNAME(LEA4MFPD)
      *
      **  Rollover Transmitted Message format
     D O1MFPD        E DS                  EXTNAME(LEO1MFPD)
      *
      **  Rollover Returned Message format
     D O2MFPD        E DS                  EXTNAME(LEO2MFPD)
      *
      **  Repayment Scheduled Transmitted Message format
     D P1MFPD        E DS                  EXTNAME(LEP1MFPD)
     D P1MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D P1MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Repayment Scheduled Returned Message format
     D P2MFPD        E DS                  EXTNAME(LEP2MFPD)
      *
      **  Manual Repayment Transmitted Message format
     D M1MFPD        E DS                  EXTNAME(LEM1MFPD)
     D M1MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D M1MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Manual Repayment Returned Message format
     D M2MFPD        E DS                  EXTNAME(LEM2MFPD)
      *
      **  Fees Transmitted Message Format
     D F3MFPD        E DS                  EXTNAME(LEF3MFPD)
     D F3MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D F3MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Fees Returned Message Format
     D F4MFPD        E DS                  EXTNAME(LEF4MFPD)
      *
      **  Fee Settlements Transmitted Message Format
     D F5MFPD        E DS                  EXTNAME(LEF5MFPD)
     D F5MFPDRONS    E                     EXTFLD(QQRONS)                                     CGL029
     D F5MFPDPONS    E                     EXTFLD(QQPONS)                                     CGL029
      *
      **  Fee Settlements Returned Message Format
     D F6MFPD        E DS                  EXTNAME(LEF6MFPD)
      *
      **  Facility Amendments Transmitted Message Format
     D A5MFPD        E DS                  EXTNAME(LEA5MFPD)
      *
      **  Facility Amendments Returned Message Format
     D A6MFPD        E DS                  EXTNAME(LEA6MFPD)
      *                                                                                       CLE011
      **  Rollover Fix Rate Message Format                                                    CLE011
     D O3MFPD        E DS                  EXTNAME(LEO3MFPD)                                  CLE011
      *                                                                                       CLE011
      **  Rollover Fix Rate Returned Message Format                                           CLE011
     D O4MFPD        E DS                  EXTNAME(LEO4MFPD)                                  CLE011
      *                                                                                       CLE011
     D PLoan         E DS                  EXTNAME(CLOANCL)                                   CLE011
     D                                     PREFIX(PL)                                         CLE011
                                                                                              CLE011
      **  PC Msg Fmt Settlement Allocation Xmit Format                                        CLE034
     D SA1MPD        E DS                  EXTNAME(LESA1MPD)                                  CLE034
                                                                                              CLE034
      **  PC Msg Fmt Settlement Allocation Return Format                                      CLE034
     D SA2MPD        E DS                  EXTNAME(LESA2MPD)                                  CLE034
                                                                                              CLE034
      **  PC Msg Fmt Settlement Allocation Return Format                                      CLE035
     D I1MFPD        E DS                  EXTNAME(LEI1MFPD)                                  CLE035
                                                                                              CLE035
      **  PC Msg Fmt Settlement Allocation Return Format                                      CLE035
     D I2MFPD        E DS                  EXTNAME(LEI2MFPD)                                  CLE035
                                                                                              CLE035
      **  Long Data Structure for Access programs.
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      **  Short Data Structure for Access programs.
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      * Program Status Data Structure
     D PGMDS         ESDS                  EXTNAME(Y2PGDSP)
      * MQI structures
      *
      * MQI named constants
     **D/COPY**QRPGLESRC,CMQR**********                                                       211959
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                   211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
      * Object Descriptor
     D MQOD            DS
     **D/COPY**QRPGLESRC,CMQODR********                                                       211959
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                 211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
      * Message Descriptor
     D MQMD            DS
     **D/COPY**QRPGLESRC,CMQMDR********                                                       211959
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                 211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
      * Get message options
     D MQGMO           DS
     **D/COPY**QRPGLESRC,CMQGMOR*******                                                       211959
     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
      * Put message options
     D MQPMO           DS
     **D/COPY**QRPGLESRC,CMQPMOR*******                                                       211959
     D***/COPYQMQM/QRPGLESRC,CMQPMOR                                                 211959 MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
      *
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
      *
      *
     D BRRMSG          DS
     D  W#MSGS                81     81
     D  W#MSID                82     88
     D  W#MSTX                89    166
      *
      *
     D INVMSG          DS           256
     D  W#FST80                1     80
     D  W#MSSS                81     81
     D  W#MSSD                82     88
     D  W#MSSX                89    166
      *
     D DATA            DS          1024
      /COPY WNCPYSRC,LE2010D001
      *
     D SPARE           DS           256
     D  WNMSGT                 1      4                                                       209692
     D  WNTNRF                37     51                                                       209692
     D  WNMSGS                81     81
     D  WNMSGI                82     88                                                       209692
     D  WNMSTX                89    166                                                       209692
      *                                                                                       202393
      * Need to know if message is to be repaired in back office.                             202393
     D W#RPRLOCDS      DS            80                                                       202393
     D  W#RPRLOC              77     77                                                       202393
      *
      * Local data area for database error details
     D DBERR         E DS                  EXTNAME(LDA)
     D  SPARF        E                     EXTFLD(SPARE)
      *                                                                                       209692
     D P#MESSAGE       DS          2000                                                       209692
     D  W#TNRF                37     51                                                       209692
     D  W#ACTN                56     56                                                       209692
      *
     D W#NUMOFMSG      S              4S 0 INZ(0)
     D CLE034          S              1A                                                      CLE034
     D PTimestamp      S               Z                                                      CLE034
     D WStAlocUsed     S              1A                                                      CLE034
     D WStAlocProc     S              1A                                                      CLE034
     D W1stMsgInd      S              1A                                                      CLE034
     D W1stLoanPtpu    S              1A                                                      CLE034
     D WrkSA1TMS       S               Z                                                      CLE034
     D WDefaultTS      S               Z                                                      CLE034
     D WConstantTS     S             26A   INZ('0001-01-01-00.00.00.000000')                  CLE034
      ** SAR Flags                                                                            CLE035
     D CLE035          S              1A                                                      CLE035
                                                                                              CLE035
      ** Parameters                                                                           CLE035
     D POption         S              1A                                                      CLE035
                                                                                              CLE035
      ** Work Variables                                                                       CLE035
     D*WSoldLoan       S              6S 0                                             CLE035 CLE148
     D WSoldLoan       S              6A                                                      CLE148
     D WFeeSeq         S              2S 0                                                    CLE035
     D WLastType       S              4A                                                      CLE035
                                                                                              CLE035
      ** MQ Parameters                                                                      MD041126
     D P#HCONN         S             10I 0                                                  MD041126
     D P#HOBJ          S             10I 0                                                  MD041126
     D P#OPTS          S             10I 0                                                  MD041126
     D P#CCODE         S             10I 0                                                  MD041126
     D P#RSCOD         S              9P 0                                                  MD041126
     D P#REASON        S             10I 0                                                  MD041126
     D BUFLEN          S             10I 0                                                  MD041126
     D P#QMNAME        S             48A                                                    MD041126
     D P#MLEN          S             10I 0                                                  MD041126
     D W#TEMP          S              5A                                                    MD041126
      *
      * Constant to be sent on QCMDEXEC command
     D SETDLY          C                   CONST('DLYJOB DLY(1)')
     D CLEARF          C                   CONST('CLRPFM QTEMP/LEBRMSPD')
     D CLEARBEF        C                   CONST('CLRPFM QTEMP/LEBSTLPD')                     219608
     D OVRDBF          C                   'OVRDBF FILE(FCLTY) SHARE(*NO)'
     D OVR_LEFEED      C                   'OVRDBF FILE(LEFEEDL1) SHARE(*NO)'                 149199
     D OVR_LEILONLX    C                   'OVRDBF FILE(LEILONLX) TOFILE-                     CAP053
     D                                     (LEILONL2) SHARE(*NO)'                             CAP053
     D DLT_LEILONLX    C                   'DLTOVR FILE(LEILONLX)'                            CAP053
     D OVR_LEILAMLX    C                   'OVRDBF FILE(LEILAMLX) TOFILE-                     CAP061
     D                                     (LEILAML2) SHARE(*NO)'                             CAP061
     D DLT_LEILAMLX    C                   'DLTOVR FILE(LEILAMLX)'                            CAP061
     D OVR_LEIROLLX    C                   'OVRDBF FILE(LEIROLLX) TOFILE-                     CAP062
     D                                     (LEIROLL2) SHARE(*NO)'                             CAP062
     D DLT_LEIROLLX    C                   'DLTOVR FILE(LEIROLLX)'                            CAP062
     D OVR_LEIMRPLX    C                   'OVRDBF FILE(LEIMRPLX) TOFILE-                     CAP063
     D                                     (LEIMRPL2) SHARE(*NO)'                             CAP063
     D DLT_LEIMRPLX    C                   'DLTOVR FILE(LEIMRPLX)'                            CAP063
     D OVR_LEIFEELX    C                   'OVRDBF FILE(LEIFEELX) TOFILE-                     CAP064
     D                                     (LEIFEEL2) SHARE(*NO)'                             CAP064
     D DLT_LEIFEELX    C                   'DLTOVR FILE(LEIFEELX)'                            CAP064
     D OVR_LEIFACLX    C                   'OVRDBF FILE(LEIFACLX) TOFILE-                     CAP065
     D                                     (LEIFACL2) SHARE(*NO)'                             CAP065
     D DLT_LEIFACLX    C                   'DLTOVR FILE(LEIFACLX)'                            CAP065
     D OVR_LEFCAMSQ    C                   'OVRDBF FILE(LEFCAMSQ) TOFILE-                     202546
     D                                     (LEFCAML3) SHARE(*NO)'                             202546
     D DLT_LEFCAMSQ    C                   'DLTOVR FILE(LEFCAMSQ)'                            202546
     D OVR_LESTALLX    C                   'OVRDBF FILE(LESTALLX) TOFILE-                     CLE034
     D                                     (LESTALL2) SHARE(*NO)'                             CLE034
     D DLT_LESTALLX    C                   'DLTOVR FILE(LESTALLX)'                            CLE034
     D OVR_LETISPLX    C                   'OVRDBF FILE(LETISPLX) TOFILE-                     CLE035
     D                                     (LETISPL0) SHARE(*NO)'                             CLE035
     D OVR_LETISPLY    C                   'OVRDBF FILE(LETISPLY) TOFILE-                     CLE035
     D                                     (LETISPL1) SHARE(*NO)'                             CLE035
     D OVR_LETISPLV    C                   'OVRDBF FILE(LETISPLV) TOFILE-                     CLE035
     D                                     (LETISPL3) SHARE(*NO)'                             CLE035
     D OVR_LETISPLW    C                   'OVRDBF FILE(LETISPLW) TOFILE-                     CLE035
     D                                     (LETISPL4) SHARE(*NO)'                             CLE035
      *
     D*SBMJOB********* C                   'SBMJOB (LEC0212A) JOBD(MBATCH)-                   152356
     D****************                      USER(*JOBD) RTGDTA(*JOBD)-                        152356
     D****************                      RQSDTA(''CALL LEC0212A'')-                        152356
     D****************                      INLLIBL(*JOBD) MSGQ(MOPERQ)'                      152356
     D*SBMJOB***       C                   'SBMJOB (LEC0212A) JOBD(MBATCH)-            152356 CSC023
     D**********                            USER(*JOBD) RTGDTA(*JOBD)-                 152356 CSC023
     D**********                            RQSDTA(''CALL LEC0212A'')-                 152356 CSC023
     D**********                            INLLIBL(*JOBD) MSGQ(*NONE)'                152356 CSC023
     D SBMJOB          C                   'SBMJOB (LEC0212A) JOBD(MBATCH)-                   CSC023
     D                                      USER(*JOBD) RTGDTA(*JOBD)-                        CSC023
     D                                      RQSDTA(''CALL LEC0212A'')-                        CSC023
     D                                      INLLIBL(*JOBD) MSGQ(*NONE)-                       CSC023
     D                                      OUTQ(*JOBD)'                                      CSC023
      *                                                                                       133783
     D SNDMSG          C                   'SNDMSG ''Number of messages read -                133783
     D                                     do not equal number on the batch -                 133783
     D                                     header.  Please contact -                          133783
     D                                     office.'' MSGQ(MOPERQ)'                            133783
      *                                                                                       133783
      ** Constants to be displayed on Audit Report                                            133783
      *                                                                                       133783
     D ERRM1           C                   'Number of messages read do   '                    133783
     D ERRM2           C                   'not equal number on the batch'                    133783
     D ERRM3           C                   'header.  Please contact      '                    133783
     D ERRM4           C                   'office.                      '                    133783
      *
      **********************************************************************
      *
     C     *ENTRY        PLIST
     C                   PARM                    P#SERVER          3
     C                   PARM                    P#BRANCH          3
      *
      ** Initial Processing
     C                   EXSR      INITPR
      *
      ** Main Processing
     C                   EXSR      MAIN
      * Close and exit
     C                   MOVE      *ON           *INLR
     C                   RETURN
      /EJECT
      **********************************************************************
      *  Main Processing
      **********************************************************************
     C     MAIN          BEGSR
      *
     C                   MOVE      'N'           W#STOP            1
     C     *LIKE         DEFINE    MDCID         W#MDCID
     C                   MOVE      *BLANKS       W#MDCID
     C                   MOVE      *BLANK        W1stMsgInd                                   CLE034
     C                   MOVE      'Y'           W1stLoanPtpu                                 CLE034
     C     *ISO          MOVE      WConstantTS   WDefaultTS                                   CLE034
     C                   IF        CLE035 = 'Y'                                               CLE035
     C**********         EVAL      WSoldLoan = 0                                       CLE035 CLE148
     C                   EVAL      WSoldLoan = *BLANK                                         CLE148
     C                   EVAL      WFeeSeq = 0                                                CLE035
     C                   EVAL      WLastType = *BLANKS                                        CLE035
     C                   ENDIF                                                                CLE035
      *
     C     W#STOP        DOWNE     'Y'
      *
      *
     C     W#MDCID       IFEQ      *BLANKS
     C                   MOVE      'Y'           W1stMsgInd                                   CLE034
      *
      **  Process first message in Unit of work
     C                   EXSR      FRSTMSG
      *                                                                                       202393
      **  Do not do unit of work processing if messages are to be                             202393
      **  repaired in the 'back office'. If repair location is back                           202393
      **  office clear W#MDCID so each message is processed as a                              202393
      **  first message.                                                                      202393
     C     W#RPRLOC      IFEQ      'B'                                                        202393
     C                   MOVE      *BLANKS       W#MDCID                                      202393
     C                   ENDIF                                                                202393
      *
     C                   ELSE
     C     W#MSGCOUNT    IFNE      W#NUMOFMSG
      *
      **  Process next message in Unit of work
     C                   EXSR      NEXTMSG
      *
     C                   ELSE
      *
      **  Perform Unit of Work completion
     C                   EXSR      UNITCOMP
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *              _____
      **  Attempt to CLOSE the MQ Sent Message Queue for the branch
      *              ~~~~~
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCLOS        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#SOBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM      CONONE        P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#SOBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     CONONE        P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P#HCONN : P#HOBJ : P#OPTS :                     MD041126
     C                                      P#CCODE : P#REASON )                            MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQCLOSE failed
      *
     C     P#CCODE       IFEQ      CCFAIL
     C**********         MOVEL     MQCLOS        DBKEY                                      MD041126
     C                   MOVEL     'MQCLOSE'     DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     1             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *              _____
      **  Attempt to CLOSE the MQ Returned Message Queue for the branch
      *              ~~~~~
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCLOS        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#ROBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM      CONONE        P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#ROBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     CONONE        P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCLOSE( P#HCONN : P#HOBJ : P#OPTS :                     MD041126
     C                                      P#CCODE : P#REASON )                            MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQCLOSE failed
      *
     C     P#CCODE       IFEQ      CCFAIL
     C**********         MOVEL     MQCLOS        DBKEY                                      MD041126
     C                   MOVEL     'MQCLOSE'     DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     2             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *              __________
      **  Attempt to DISCONNECT from the MQ Manager
      *              ~~~~~~~~~~
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQDISC        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQDISC( P#HCONN : P#CCODE :                              MD041126
     C                                     P#REASON )                                       MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQDISC failed
      *
     C     P#CCODE       IFEQ      CCFAIL
     C**********         MOVEL     MQDISC        DBKEY                                      MD041126
     C                   MOVEL     'MQDISC'      DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     3             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Process first message in Unit of work
      **********************************************************************
     C     FRSTMSG       BEGSR
      *
      **  Call QCMDEXC to delay the job by 1 second.
     C                   CALL      'QCMDEXC'
     C                   PARM      SETDLY        QCMD             70
     C                   PARM      13            LENGTH           15 5
      *
      *   Call confirmations processing to generate swift pay messages
      *   every 30 mins.
      *
      ** Submit confirmation job if journal entry has been committed                          155873
     C     SBMCNF        IFEQ      'Y'                                                        155873
      *                                                                                       155873
     C     CLOCK         IFGT      MINS
     C     CLOCK         ORLT      CLOCK_OLD                                                  150876
     C                   EVAL      LENGTH = %SIZE(SBMJOB)
     C                   CALL      'QCMDEXC'
     C                   PARM      SBMJOB        QCMD1           200
     C                   PARM                    LENGTH
     C                   Z-ADD     CLOCK         CLOCK_OLD         6 0                        150876
     C                   Z-ADD     CLOCK         MINS              6 0
     C*******************ADD       3000          MINS                                   131256142225
     C                   ADD       500           MINS                                         142225
     C                   MOVE      ' '           SBMCNF                                       155873
     C                   ENDIF
      *
     C                   TIME                    CLOCK             6 0
      *                                                                                       155873
     C                   ENDIF                                                                155873
      *
     C                   MOVE      'N'           W#ERROR           1
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C     *ISO          MOVE      WConstantTS   WrkSA1TMS                                    CLE034
      *
      **  Call LEC2010R to retrieve server dataarea
     C                   CALL      'LEC2010R'
     C                   PARM                    W#DTAARA
     C                   PARM                    W#STOP
      *
     C     W#STOP        IFNE      'Y'
      *
      **  Set count of messages
     C                   Z-ADD     1             W#MSGCOUNT
      *
      **  Set failed access
     C                   Z-ADD     0             W#FAILACES        3 0
      *
     C                   MOVE      *BLANKS       P#MESSAGE
      *   ___
      **  GET a message from the MQ Sent Message Queue
      *   ~~~
      **  No report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  No selection criteria
     C                   MOVE      CINONE        MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  options are Immidiate return if no message available and
      **  conversion of message data with syncpoint control
     C     GMNWT         ADD       GMSYP         GMOPT
     C                   ADD       GMCONV        GMOPT
      *
      **  length of buffer available
     C                   Z-ADD     2000          BUFLEN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQGET         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#SOBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    P#MESSAGE      2000                        MD041126
     C**********         PARM      2000          P#MLEN            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#SOBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     2000          P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQGMO : BUFLEN :                           MD041126
     C                                    %ADDR(P#MESSAGE) :P#MLEN :                        MD041126
     C                                    P#CCODE : P#REASON )                              MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQGET failed
      *
     C     P#CCODE       IFGT      *ZERO
     C     P#RSCOD       ANDNE     2033
     C*********          MOVEL     MQGET         DBKEY                                      MD041126
     C                   MOVEL     'MQGET'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     4             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P#MESSAGE     IFNE      *BLANKS
      *
      **  Set Correlation ID.
     C                   MOVE      MDCID         W#MDCID
      *
      **  Set Message Type
     C                   MOVEL     P#MESSAGE     W#MSGT            4
      *                                                                                       202393
      **  Set Repair location via DS W#RPRLOCDS                                               202393
     C                   MOVEL     P#MESSAGE     W#RPRLOCDS                                   202393
      *
      **  Set message type format according to message type processed
     C                   EXSR      SETMSG
      *
      **  If SAR CLE005 is installed
      *
     C     CLE005        IFEQ      'Y'
      *
     C     W#MSGT        IFEQ      'FEES'
     C                   MOVE      F3NRBA        W#F3NRBA          4 0
     C                   Z-ADD     W#F3NRBA      W#NUMOFMSG
     C                   ENDIF
     C*****W#F3NRBA      IFEQ      1                                                          132762
     C     F3FCNO        IFNE      *BLANKS                                                    132762
     C     F3LOAN        ORNE      *BLANKS                                                    132762
     C                   Z-ADD     0             W#PCNO                                       132762
     C                   ENDIF                                                                132762
      *
     C     W#MSGT        IFEQ      'FSET'
     C                   MOVE      F5NRBA        W#F5NRBA          4 0
     C                   Z-ADD     W#F5NRBA      W#NUMOFMSG
     C                   ENDIF
      *
     C     W#MSGT        IFEQ      'FAFD'
     C     W#MSGT        OREQ      'FAFI'
     C     W#MSGT        OREQ      'FAFR'
     C     W#MSGT        OREQ      'FARC'
     C                   MOVE      A5NRBA        W#A5NRBA          4 0
     C                   Z-ADD     W#A5NRBA      W#NUMOFMSG
     C     A5FCNO        IFNE      *BLANKS                                                    157907
     C                   Z-ADD     0             W#PCNO                                       157907
     C                   ENDIF                                                                157907
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   SELECT
      *
     C     W#MSGT        WHENEQ    'FCTY'
     C     W#MSGT        OREQ      'FCFP'                                                     157911
     C                   Z-ADD     F1NRBA        W#NUMOFMSG
      *
     C     CLE005        WHENEQ    'Y'                                                        157911
     C     W#MSGT        ANDEQ     'FCRP'                                                     157911
     C                   Z-ADD     R1NRBA        W#NUMOFMSG                                   157911
      *                                                                                       157911
     C     W#MSGT        WHENEQ    'LOAN'
     C     W#MSGT        OREQ      'PTPU'
     C     W#MSGT        OREQ      'PTSO'
     C                   Z-ADD     N1NRBA        W#NUMOFMSG
      *
     C     W#MSGT        WHENEQ    'LABC'
     C     W#MSGT        OREQ      'LALS'
     C     W#MSGT        OREQ      'LAPF'
     C     W#MSGT        OREQ      'LAPI'
     C     W#MSGT        OREQ      'LAPT'
     C     W#MSGT        OREQ      'LASA'
     C     W#MSGT        OREQ      'LASC'
     C     W#MSGT        OREQ      'LAPD'                                                     226033
     C                   Z-ADD     A1NRBA        W#NUMOFMSG
      *
     C     W#MSGT        WHENEQ    'ROLL'
     C                   Z-ADD     O1NRBA        W#NUMOFMSG
      *
     C     W#MSGT        WHENEQ    'LARE'
     C                   Z-ADD     P1NRBA        W#NUMOFMSG
      *
     C     W#MSGT        WHENEQ    'LAMR'
     C                   Z-ADD     M1NRBA        W#NUMOFMSG
      *                                                                                       CLE011
      ** If CLE011 is installed, set the number of message in the Unit of                     CLE011
      ** Work                                                                                 CLE011
      *                                                                                       CLE011
     C     CLE011        WHENEQ    'Y'                                                        CLE011
     C     W#MSGT        ANDEQ     'RTFX'                                                     CLE011
     C                   Z-ADD     O3NRBA        W#NumofMsg                                   CLE011
                                                                                              CLE034
     C                   WHEN      CLE034 = 'Y'                                               CLE034
     C                             AND W#MSGT = 'STAL'                                        CLE034
     C                   EVAL      W#NumofMsg = SA1NRB                                        CLE034
                                                                                              CLE035
      ** If CLE035 is installed, W#NumofMsg will be set to Number of Records                  CLE035
      ** in Batch                                                                             CLE035
                                                                                              CLE035
     C                   WHEN      CLE035 = 'Y'                                               CLE035
     C                             AND W#MSGT = 'TISP'                                        CLE035
     C                   EVAL      W#NumofMsg = I1NRBA                                        CLE035
      *
     C                   ENDSL
      *
     C                   EXSR      PROMSG
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Process next message in Unit of work
      **********************************************************************
     C     NEXTMSG       BEGSR
      *
      **
     C     W#STOP        IFNE      'Y'
      *
     C                   MOVE      *BLANKS       P#MESSAGE
      *   ___
      **  GET a message from the MQ Sent Message Queue
      *   ~~~
      **  No report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  Selection on correlation ID.
     C                   MOVE      W#MDCID       MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  options are Immidiate return if no message available and
      **  conversion of message data with syncpoint control
     C     GMNWT         ADD       GMSYP         GMOPT
     C                   ADD       GMCONV        GMOPT
      *
      **  length of buffer available
     C                   Z-ADD     2000          BUFLEN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQGET         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#SOBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    P#MESSAGE      2000                        MD041126
     C**********         PARM      2000          P#MLEN            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#SOBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     2000          P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQGMO : BUFLEN :                           MD041126
     C                                    %ADDR(P#MESSAGE) :P#MLEN :                        MD041126
     C                                    P#CCODE : P#REASON )                              MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQGET failed
      *
     C     P#CCODE       IFGT      *ZERO
     C     P#RSCOD       ANDNE     2033
     C**********         MOVEL     MQGET         DBKEY                                      MD041126
     C                   MOVEL     'MQGET'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     P#MESSAGE     IFNE      *BLANKS
      *
      *
      **  Add 1 to count of messages
     C                   ADD       1             W#MSGCOUNT        4 0
      *
      **  Set Message Type
     C                   MOVEL     P#MESSAGE     W#MSGT
      *
      **  Set message type format according to message type processed
     C                   EXSR      SETMSG
      *
     C     W#MSGT        IFEQ      'FAFD'                                                     157907
     C     W#MSGT        OREQ      'FAFI'                                                     157907
     C     W#MSGT        OREQ      'FAFR'                                                     157907
     C     W#MSGT        OREQ      'FARC'                                                     157907
     C     A5FCNO        IFNE      *BLANKS                                                    157907
     C                   Z-ADD     0             W#PCNO                                       157907
     C                   ENDIF                                                                157907
     C                   ENDIF                                                                157907
      *
     C                   EXSR      PROMSG
      *
     C                   ELSE
      *
     C                   ADD       1             W#FAILACES
      *
      **  Call QCMDEXC to delay the job by 1 second.
     C                   CALL      'QCMDEXC'
     C                   PARM      SETDLY        QCMD
     C                   PARM      13            LENGTH           15 5
      *
      *
     C     W#FAILACES    IFEQ      100
     C**********         MOVEL     MQGET         DBKEY                                      MD041126
     C                   MOVEL     'MQGET'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     6             DBASE
      *                                                                                       133783
      ** Display clear message                                                                133783
      *                                                                                       133783
     C**********         MOVEL     MQGET         W#TEMP            1                 133783 MD041126
     C*****W#TEMP        IFEQ      '5'                                               133783 MD041126
     C                   MOVEL     'MQGET'       W#TEMP                                     MD041126
     C                   IF        W#TEMP = 'MQGET'                                         MD041126
      *                                                                                       133783
      ** Send Error Message to MOPERQ                                                         133783
      *                                                                                       133783
     C                   EVAL      LENGTH = %SIZE(SNDMSG)                                     133783
     C                   CALL      'QCMDEXC'                                                  133783
     C************       PARM      SNDMSG        QCMD                                         133783
     C                   PARM      SNDMSG        QCMD1                                        133783
     C                   PARM                    LENGTH                                       133783
      *                                                                                       133783
      ** Display Error Message in Audit Report                                                133783
      *                                                                                       133783
     C                   MOVEL     ERRM1         DBMSG1                                       133783
     C                   MOVEL     ERRM2         DBMSG2                                       133783
     C                   MOVEL     ERRM3         DBMSG3                                       133783
     C                   MOVEL     ERRM4         DBMSG4                                       133783
     C                   MOVE      *ON           *IN31                                        133783
     C                   ENDIF                                                                133783
      *                                                                                       133783
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Process unit of work completion
      **********************************************************************
     C     UNITCOMP      BEGSR
      *
      ** Close file LEBSTLPD by calling AOBSTLR0 with Option '*FREE':                         219608
     C                   CALL      'AOBSTLR0'                                                 219608
     C                   PARM      *BLANKS       STALCD            7                          219608
     C                   PARM      '*FREE'       POPTN             7                          219608
     C                   PARM      *BLANKS       PTYPE             4                          219608
     C                   PARM      *BLANKS       PLNRF             6                          219608
     C                   PARM      *BLANKS       PVDAT             5                          219608
     C                   PARM      *BLANKS       PLASN             3                          219608
     C                   PARM      *BLANKS       PCNUM             6                          219608
     C                   PARM      *BLANKS       PFACL             5                          219608
     C                   PARM      *BLANKS       PFSEQ             2                          219608
     C                   PARM      *BLANKS       PPYRC             1                          219608
     C**********         PARM      *BLANKS       PDSDY           765                   219608 CLE038
     C                   PARM      *BLANKS       DSSDY                                        CLE038
      **  Then Call QCMDEXC to clear LEBSTLPD                                                 219608
     C                   CALL      'QCMDEXC'                                                  219608
     C                   PARM      CLEARBEF      QCMD                                         219608
     C                   PARM      21            LENGTH           15 5                        219608
      *                                                                                       219608
     C     W#STOP        IFNE      'Y'
                                                                                              CLE034
      ** If this switchable feature is on and Work Settlement Allocations Used                CLE034
      ** is equal to 'Y' and Work Settlement Allocations Processed is not equal               CLE034
      ** to 'Y', then have had a setttlement allocations message but no transaction           CLE034
      ** message attached which is an error.                                                  CLE034
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                             AND WStAlocUsed = 'Y'                                      CLE034
     C                             AND WStAlocProc <>'Y'                                      CLE034
     C                   EVAL      W#ERROR = 'Y'                                              CLE034
     C                   ENDIF                                                                CLE034
      *
      **  If no validation errors for the unit of work
     C     W#ERROR       IFEQ      'N'
      *
     C                   COMMIT
      *
      ** Set flag to submit confirmation job if unit of work complete                         155873
     C                   MOVE      'Y'           SBMCNF                                       155873
      *                                                                                       155873
     C                   ELSE
      *
     C                   ROLBK
      *
     C                   MOVE      *BLANKS       P#MESSAGE
      *   ___
      **  GET a message from the MQ Sent Message Queue
      *   ~~~
      **  No report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  Selection on correlation ID.
     C                   MOVE      W#MDCID       MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  options are Immidiate return if no message available and
      **  conversion of message data with syncpoint control
     C     GMNWT         ADD       GMSYP         GMOPT
     C                   ADD       GMCONV        GMOPT
      *
      **  length of buffer available
     C                   Z-ADD     2000          BUFLEN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQGET         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#SOBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    P#MESSAGE      2000                        MD041126
     C**********         PARM      2000          P#MLEN            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#SOBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     2000          P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQGMO : BUFLEN :                           MD041126
     C                                    %ADDR(P#MESSAGE) :P#MLEN :                        MD041126
     C                                    P#CCODE : P#REASON )                              MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQGET failed
      *
     C     P#CCODE       IFGT      *ZERO
     C     P#RSCOD       ANDNE     2033
     C**********         MOVEL     MQGET         DBKEY                                      MD041126
     C                   MOVEL     'MQGET'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     7             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Do while messages exist for the Correlation ID.
      *
     C     P#MESSAGE     DOWNE     *BLANKS
      *
     C                   MOVE      *BLANKS       P#MESSAGE
      *   ___
      **  GET a message from the MQ Sent Message Queue
      *   ~~~
      **  No report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  Selection on correlation ID.
     C                   MOVE      W#MDCID       MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  options are Immidiate return if no message available and
      **  conversion of message data with syncpoint control
     C     GMNWT         ADD       GMSYP         GMOPT
     C                   ADD       GMCONV        GMOPT
      *
      **  length of buffer available
     C                   Z-ADD     2000          BUFLEN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQGET         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#SOBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    P#MESSAGE      2000                        MD041126
     C**********         PARM      2000          P#MLEN            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#SOBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     2000          P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQGET( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQGMO : BUFLEN :                           MD041126
     C                                    %ADDR(P#MESSAGE) :P#MLEN :                        MD041126
     C                                    P#CCODE : P#REASON )                              MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQGET failed
      *
     C     P#CCODE       IFGT      *ZERO
     C     P#RSCOD       ANDNE     2033
     C**********         MOVEL     MQGET         DBKEY                                      MD041126
     C                   MOVEL     'MQGET'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     8             DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDDO
      *
      *
      **  Selection on correlation ID.
     C                   MOVE      W#MDCID       MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  Access first record from branch message work file
     C                   READ      LEBRMSPD                               80
      *
     C     *IN80         IFEQ      *OFF
      *
     C     W#MSGS        IFEQ      ' '
     C     W#MSGS        OREQ      'W'
     C                   MOVE      'E'           W#MSGS
     C                   MOVE      'LEX9999'     W#MSID
     C                   MOVEL     'LEX9999'     ZAMSID
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDAT         132
     C                   PARM                    ZAMSTX          132
      *
     C                   MOVEL     ZAMSTX        W#MSTX
     C                   MOVEL(P)  BRRMSG        W#RMSG
      *
     C                   ENDIF
      *
     C     *IN80         DOWEQ     *OFF
      *
      **  Move details from LEBRMSPD to Return format
     C                   MOVEL     BRRMSG        W#RMSG
      *
      **  Put message
     C                   MOVEL     A8MQRT        ODON
      *
      **  Report Options: no report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  Specify that Format name consists entirely of characters
     C                   MOVEL     FMSTR         MDFMT
      *
      **  Message Type: message not requiring a reply
     C                   Z-ADD     MTDGRM        MDMT
      *
      **  Message Priority: default priority
     C                   Z-ADD     PRQDEF        MDPRI
      *
      **  Message Persistence: message has default persistent
     C                   Z-ADD     PEQDEF        MDPER
      *
      **  with syncpoint control
     C                   Z-ADD     PMSYP         PMOPT
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQPUT         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#ROBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM      W#MLEN        P#MLEN            9 0                      MD041126
     C**********         PARM                    W#RMSG                                     MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#ROBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     W#MLEN        P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQPMO : P#MLEN :                           MD041126
     C                                    %ADDR(W#RMSG) : P#CCODE :                         MD041126
     C                                    P#REASON )                                        MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQPUT failed
     C     P#CCODE       IFNE      CCOK
     C**********         MOVEL     MQPUT         DBKEY                                      MD041126
     C                   MOVEL     'MQPUT'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     31            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Access next record from LEBRMSPD
     C                   READ      LEBRMSPD                               80
      *
     C                   ENDDO
      *
      **  Commit all writes of messages to the Returned Queue
     C                   COMMIT
      *
     C                   ENDIF
      *
      **  Commit all writes of messages to the Returned Queue
     C                   COMMIT
      *
     C                   ENDIF
      *
      **  Set Correlation ID to blank
     C                   MOVE      *BLANKS       W#MDCID
     C                   MOVE      MINONE        MDMID
      *
      **  Set Number of messages to 0
     C                   Z-ADD     0             W#NUMOFMSG
      *
     C                   CLOSE     LEBRMSPD
      *
      **  Call QCMDEXC to clear LEBRMSPD
     C                   CALL      'QCMDEXC'
     C                   PARM      CLEARF        QCMD
     C                   PARM      21            LENGTH           15 5
      *
     C                   OPEN      LEBRMSPD
      *
     C                   ENDIF
      *
      ** Clear P#LNRF when unit of work has completed                                         156295
      *                                                                                       156295
     C**********         Z-ADD     *ZERO         P#LNRF                                156295 CLE148
     C                   MOVEL     *BLANKS       P#LNRF                                       CLE148
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   MOVE      'Y'           W1stLoanPtpu                                 CLE034
     C     *ISO          MOVE      WConstantTS   WrkSA1TMS                                    CLE034
     C                   IF        CLE035 = 'Y'                                               CLE035
     C**********         EVAL      WSoldLoan = 0                                       CLE035 CLE148
     C                   EVAL      WSoldLoan = *BLANK                                         CLE148
     C                   EVAL      WFeeSeq = 0                                                CLE035
     C                   EVAL      WLastType = *BLANKS                                        CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       156295
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Setup Mesage format
      **********************************************************************
     C     SETMSG        BEGSR
      *
     C                   SELECT
      *
     C     W#MSGT        WHENEQ    'FCTY'
     C     W#MSGT        OREQ      'FCFP'
     C                   MOVEL     P#MESSAGE     F1MFPD
     C                   MOVE      *BLANKS       F2MFPD
      *
      **  If SAR CLE005 is installed
      *
     C     CLE005        WHENEQ    'Y'
     C     W#MSGT        ANDEQ     'FCRP'
     C                   MOVEL     P#MESSAGE     R1MFPD
     C                   MOVE      *BLANKS       R2MFPD
      *
     C     CLE005        WHENEQ    'Y'
     C     W#MSGT        ANDEQ     'FEES'
     C                   MOVEL     P#MESSAGE     F3MFPD
     C                   MOVE      *BLANKS       F4MFPD
      *
     C     CLE005        WHENEQ    'Y'
     C     W#MSGT        ANDEQ     'FSET'
     C                   MOVEL     P#MESSAGE     F5MFPD
     C                   MOVE      *BLANKS       F6MFPD
      *
     C     CLE005        WHENEQ    'Y'
     C     W#MSGT        ANDEQ     'FAFD'
     C     CLE005        OREQ      'Y'
     C     W#MSGT        ANDEQ     'FAFI'
     C     CLE005        OREQ      'Y'
     C     W#MSGT        ANDEQ     'FAFR'
     C     CLE005        OREQ      'Y'
     C     W#MSGT        ANDEQ     'FARC'
     C                   MOVEL     P#MESSAGE     A5MFPD
     C                   MOVE      *BLANKS       A6MFPD
      *
     C     W#MSGT        WHENEQ    'FCRP'
     C     W#MSGT        OREQ      'FCAS'
     C                   MOVEL     P#MESSAGE     R1MFPD
     C                   MOVE      *BLANKS       R2MFPD
      *
     C     W#MSGT        WHENEQ    'LOAN'
     C     W#MSGT        OREQ      'PTPU'
     C     W#MSGT        OREQ      'PTSO'
     C                   MOVEL     P#MESSAGE     N1MFPD
     C                   MOVE      *BLANKS       N2MFPD
     C/COPY WNCPYSRC,LE2010MC02
      *
     C     W#MSGT        WHENEQ    'LABC'
     C     W#MSGT        OREQ      'LALS'
     C     W#MSGT        OREQ      'LAPF'
     C     W#MSGT        OREQ      'LAPI'
     C     W#MSGT        OREQ      'LAPT'
     C     W#MSGT        OREQ      'LASA'
     C     W#MSGT        OREQ      'LASC'
     C     W#MSGT        OREQ      'LAPD'                                                     226033
     C                   MOVEL     P#MESSAGE     A1MFPD
     C*****              MOVE      *BLANKS       A1MFPD
     C                   MOVE      *BLANKS       A2MFPD
      *
     C     W#MSGT        WHENEQ    'ROLL'
     C                   MOVEL     P#MESSAGE     O1MFPD
     C                   MOVE      *BLANKS       O2MFPD
      *
     C     W#MSGT        WHENEQ    'LARE'
     C                   MOVEL     P#MESSAGE     P1MFPD
     C                   MOVE      *BLANKS       P2MFPD
      *
     C     W#MSGT        WHENEQ    'LAMR'
     C                   MOVEL     P#MESSAGE     M1MFPD
     C                   MOVE      *BLANKS       M2MFPD
      *                                                                                       CLE011
     C     W#MSGT        WHENEQ    'RTFX'                                                     CLE011
     C     CLE011        ANDEQ     'Y'                                                        CLE011
     C                   MOVEL     P#MESSAGE     O3MFPD                                       CLE011
     C                   MOVE      *BLANKS       O4MFPD                                       CLE011
                                                                                              CLE034
     C                   WHEN      CLE034 = 'Y'                                               CLE034
     C                             AND W#MSGT = 'STAL'                                        CLE034
     C                   MOVEL     P#MESSAGE     SA1MPD                                       CLE034
     C                   MOVE      *BLANKS       SA2MPD                                       CLE034
                                                                                              CLE035
     C                   WHEN      CLE035 = 'Y' AND W#MSGT = 'TISP'                           CLE035
                                                                                              CLE035
     C                   EVAL      I1MFPD = P#MESSAGE                                         CLE035
     C                   EVAL      I2MFPD = *BLANKS                                           CLE035
      *
     C                   ENDSL
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Process Message
      **********************************************************************
     C     PROMSG        BEGSR
      *
      *
     C                   MOVE      *BLANKS       RTCODE            9                          209692
     C                   MOVE      *BLANKS       ERRMSG           78                          209692
      *                                                                                       209692
      * For inserts, check if PCRF is unique but do not attempt to apply                      209692
      * the results to the return message until it has been generated by                      209692
      * the transaction handling program.                                                     209692
      *                                                                                       209692
     C     W#ACTN        IFEQ      'I'                                                        209692
     C                   CALL      'LE2025'                                                   209692
     C                   PARM                    W#TNRF                                       209692
     C                   PARM                    W#MSGT                                       209692
     C                   PARM                    RTCODE                                       209692
     C                   PARM                    ERRMSG                                       209692
     C                   ENDIF                                                                209692
      *                                                                                       209692
     C                   SELECT
      *
      **
      *
     C     W#MSGT        WHENEQ    'FCTY'
      *
     C                   EVAL      LENGTH = %SIZE(OVRDBF)
     C                   CALL      'QCMDEXC'
     C                   PARM      OVRDBF        QCMD
     C                   PARM                    LENGTH
      *
     C     CAP065        IFEQ      'Y'                                                        CAP065
     C                   EVAL      LENGTH = %SIZE(OVR_LEIFACLX)                               CAP065
     C                   CALL      'QCMDEXC'                                                  CAP065
     C                   PARM      OVR_LEIFACLX  QCMD                                         CAP065
     C                   PARM                    LENGTH                                       CAP065
     C                   ENDIF                                                                CAP065
      *                                                                                       CAP065
     C                   CALL      'LE2020'
     C                   PARM                    P#MODE
     C                   PARM                    F1MFPD
     C                   PARM                    F2MFPD
      *                                                                                       CAP065
     C     CAP065        IFEQ      'Y'                                                        CAP065
     C                   EVAL      LENGTH = %SIZE(DLT_LEIFACLX)                               CAP065
     C                   CALL      'QCMDEXC'                                                  CAP065
     C                   PARM      DLT_LEIFACLX  QCMD                                         CAP065
     C                   PARM                    LENGTH                                       CAP065
     C                   ENDIF                                                                CAP065
      *
     C     F2MSGS        IFEQ      'D'
      *
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2020'      DBFILE
     C                   Z-ADD     9             DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     W#MSGCOUNT    IFEQ      1                                                          143614
     C     *LIKE         DEFINE    F2FCNO        W#FCNO
     C                   Z-ADD     F2FCNO        W#FCNO
     C                   ENDIF                                                                143614
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           F2MSGS                                       209692
     C                   MOVE      'LEX9993'     F2MSGI                                       209692
     C                   MOVE      ERRMSG        F2MSTX                                       209692
     C                   ENDIF                                                                209692
     C*                                                                                       209692
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           F2MSGS                                       209692
     C                   MOVE      'LEX9994'     F2MSGI                                       209692
     C                   MOVE      ERRMSG        F2MSTX                                       209692
     C                   ENDIF                                                                209692
     C*                                                                                       209692
     C     F2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  F2MFPD        W#RMSG          256
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'FCFP'
      *
     C     W#FCNO        IFNE      0
     C     F1PMFN        ORNE      0                                                          202396
      *                                                                                       202396
      ** BE AWARE W#FCNO is only set if FCTY is processed first.                              202396
      *
     C     W#FCNO        IFNE      0                                                          202396
     C     F1PMFN        ANDEQ     0                                                          202396
     C                   MOVE      W#FCNO        F1PMFN
     C                   ENDIF                                                                202396
      *
     C                   CALL      'LE2021'
     C                   PARM                    P#MODE
     C                   PARM                    F1MFPD
     C                   PARM                    F2MFPD
      *
     C     F2MSGS        IFEQ      'D'
      *
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2021'      DBFILE
     C                   Z-ADD     10            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *
     C     *LIKE         DEFINE    F2FCNO        W#PCNO                                       132762
     C                   Z-ADD     F2FCNO        W#PCNO                                       132762
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           F2MSGS                                       209692
     C                   MOVE      'LEX9993'     F2MSGI                                       209692
     C                   MOVE      ERRMSG        F2MSTX                                       209692
     C                   ENDIF                                                                209692
     C*                                                                                       209692
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           F2MSGS                                       209692
     C                   MOVE      'LEX9994'     F2MSGI                                       209692
     C                   MOVE      ERRMSG        F2MSTX                                       209692
     C                   ENDIF                                                                209692
     C*                                                                                       209692
     C     F2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  F2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'E'           W#MSSS
     C                   MOVE      'LEX9997'     W#MSSD
     C                   MOVEL     'LEX9997'     ZAMSID
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDAT         132
     C                   PARM                    ZAMSTX          132
      *
     C                   MOVEL     ZAMSTX        W#MSSX
     C                   MOVEL     F1MFPD        W#FST80
     C                   MOVEL(P)  INVMSG        W#RMSG
      *
     C                   EXSR      PUTMSG
      *
     C                   DUMP
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'FCRP'
     C     CLE005        ANDEQ     'Y'
      *
     C     W#FCNO        IFNE      0
     C     R1FCNO        ORNE      0                                                          202396
      *                                                                                       202396
      ** BE AWARE W#FCNO is only set if FCTY is processed first.                              202396
      *
     C     R1FCNO        IFEQ      0
     C     W#FCNO        ANDNE     0                                                          202396
     C                   Z-ADD     W#FCNO        R1FCNO
     C                   ENDIF
      *
     C                   CALL      'LE2022'
     C                   PARM                    P#MODE
     C                   PARM                    R1MFPD
     C                   PARM                    R2MFPD
      *
     C     R2MSGS        IFEQ      'D'
      *
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2022'      DBFILE
     C                   Z-ADD     11            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           R2MSGS                                       209692
     C                   MOVE      'LEX9993'     R2MSGI                                       209692
     C                   MOVE      ERRMSG        R2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           R2MSGS                                       209692
     C                   MOVE      'LEX9994'     R2MSGI                                       209692
     C                   MOVE      ERRMSG        R2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     R2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  R2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'E'           W#MSSS
     C                   MOVE      'LEX9997'     W#MSSD
     C                   MOVEL     'LEX9997'     ZAMSID
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDAT         132
     C                   PARM                    ZAMSTX          132
      *
     C                   MOVEL     ZAMSTX        W#MSSX
     C                   MOVEL     F1MFPD        W#FST80
     C                   MOVEL(P)  INVMSG        W#RMSG
      *
     C                   EXSR      PUTMSG
      *
     C                   DUMP
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'FCAS'
      *
      *
     C     W#FCNO        IFNE      0
      *
     C     R1FCNO        IFEQ      0
     C                   Z-ADD     W#FCNO        R1FCNO
     C                   ENDIF
      *
     C                   EVAL      LENGTH = %SIZE(OVRDBF)                                     134390
     C                   CALL      'QCMDEXC'                                                  134390
     C                   PARM      OVRDBF        QCMD                                         134390
     C                   PARM                    LENGTH                                       134390
      *                                                                                       134390
     C                   CALL      'LE2023'
     C                   PARM                    P#MODE
     C                   PARM                    R1MFPD
     C                   PARM                    R2MFPD
      *
     C     R2MSGS        IFEQ      'D'
      *
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2023'      DBFILE
     C                   Z-ADD     12            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           R2MSGS                                       209692
     C                   MOVE      'LEX9993'     R2MSGI                                       209692
     C                   MOVE      ERRMSG        R2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           R2MSGS                                       209692
     C                   MOVE      'LEX9994'     R2MSGI                                       209692
     C                   MOVE      ERRMSG        R2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     R2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  R2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'E'           W#MSSS
     C                   MOVE      'LEX9997'     W#MSSD
     C                   MOVEL     'LEX9997'     ZAMSID
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDAT         132
     C                   PARM                    ZAMSTX          132
      *
     C                   MOVEL     ZAMSTX        W#MSSX
     C                   MOVEL     R1MFPD        W#FST80
     C                   MOVEL(P)  INVMSG        W#RMSG
      *
     C                   EXSR      PUTMSG
      *
     C                   DUMP
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LOAN'
     C     W#MSGT        OREQ      'PTPU'
      *
     C     W#MSGT        IFEQ      'PTPU'
     C*****W#MSGCOUNT    ANDGT     1                                                          CLE034
     C     W1stLoanPtpu  ANDNE     'Y'                                                        CLE034
     C*****N1SLNO        ANDEQ     0                                                 148191   CSD027
     C***********        Z-ADD     W#LNRF        N1SLNO                                       CSD027
     C     N1SLNO        AndEq     *Blanks                                                    CSD027
     C                   Move      W#LNRF        N1SLNO                                       CSD027
     C                   ENDIF
      *
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2030'
     C                   PARM                    P#MODE
     C                   PARM      W#MSGT        P#MSGT            4
     C                   PARM                    N1MFPD
     C                   PARM                    N2MFPD
     C                   PARM                    PTimestamp                                   CLE034
     C/COPY WNCPYSRC,LE2010MC03
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     N2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2030'      DBFILE
     C                   Z-ADD     13            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           N2MSGS                                       209692
     C                   MOVE      'LEX9993'     N2MSGI                                       209692
     C                   MOVE      ERRMSG        N2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           N2MSGS                                       209692
     C                   MOVE      'LEX9994'     N2MSGI                                       209692
     C                   MOVE      ERRMSG        N2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     N2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C     *LIKE         DEFINE    N2LNRF        W#LNRF
     C*****W#MSGCOUNT    IFEQ      1                                                          CLE034
     C     W1stLoanPtpu  IFEQ      'Y'                                                        CLE034
     C**********         Z-ADD     N2LNRF        W#LNRF                                       CLE148
     C                   MOVEL     N2LNRF        W#LNRF                                       CLE148
     C                   ENDIF
     C                   MOVE      *BLANKS       W1stLoanPtpu                                 CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
                                                                                              CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       146971
     C     *LIKE         DEFINE    N2LNRF        P#LNRF                                       146971
     C     W#MSGT        IFEQ      'PTPU'                                                     146971
     C**********         Z-ADD     N2LNRF        P#LNRF                                146971 CLE148
     C                   MOVEL     N2LNRF        P#LNRF                                       CLE148
     C                   ENDIF                                                                146971
      *                                                                                       146971
     C                   IF        CLE035 = 'Y'                                               CLE035
     C                   EVAL      WLastType = W#MSGT                                         CLE035
     C                   ENDIF                                                                CLE035
      *                                                                                       CLE035
     C     *LIKE         DEFINE    N1TOLN        W#TOLN
      *
     C     N1GPRT        IFEQ      'Y'
     C**********         Z-ADD     N2LNRF        W#TOLN                                       CLE148
     C                   MOVEL     N2LNRF        W#TOLN                                       CLE148
     C                   ELSE
     C**********         Z-ADD     0             W#TOLN                                       CLE148
     C                   MOVEL     *BLANKS       W#TOLN                                       CLE148
     C                   ENDIF
      *
     C                   MOVEL(P)  N2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'PTSO'
      *
     C*****N1SLNO        IFEQ      0                                                          CSD027
     C*****              Z-ADD     W#LNRF        N1LNRF
     C***********        Z-ADD     W#LNRF        N1SLNO                                       CSD027
     C     N1SLNO        IfEq      *Blanks                                                    CSD027
     C                   Move      W#LNRF        N1SLNO                                       CSD027
      *                                                                                       146971
      ** For Risk Part. Sold, the loan to which it relates should be                          146971
      ** the Internal Participation Purchased.                                                146971
      *                                                                                       146971
     C                   MOVEL     N1LTYP        W@LNTY            2                          146971
     C                   MOVEL     N1SUTP        W@LNST            2                          146971
     C                   CALL      'AOLOANR0'                                                 146971
     C                   PARM      *BLANKS       W@RTCD                                       146971
     C                   PARM      '*KEY'        W@OPTN                                       146971
     C                   PARM                    W@LNTY                                       146971
     C                   PARM                    W@LNST                                       146971
     C     SDLOAN        PARM      SDLOAN        DSFDY                                        146971
      *                                                                                       146971
     C     W@RTCD        IFNE      *BLANKS                                                    146971
     C                   MOVEL     W@LNTY        DBKEY                                        146971
     C                   MOVE      W@LNST        DBKEY                                        146971
     C                   MOVEL     'SDLOANPD'    DBFILE                                       146971
     C                   Z-ADD     32            DBASE                                        146971
     C                   EXSR      *PSSR                                                      146971
     C                   ELSE                                                                 146971
     C                   Z-ADD     AYLNPT        WLNPT             2 0                        146971
     C                   ENDIF                                                                146971
     C     WLNPT         IFEQ      72                                                         146971
      *                                                                                       156295
      ** Use risk loan number for sale of loan if this is risk part                           156295
      ** sold against guarantee loan else use internal part purchased                         156295
      *                                                                                       156295
     C*****P#LNRF        IFEQ      0                                                   156295 160096
     C     N1RISK        IFEQ      'F'                                                        160096
     C***********        Z-ADD     W#LNRF        N1SLNO                               156295  CSD027
     C                   Move      W#LNRF        N1SLNO                                       CSD027
      *                                                                                       156295
     C                   ELSE                                                                 156295
      *                                                                                       156295
     C***********        Z-ADD     P#LNRF        N1SLNO                               146971  CSD027
     C                   Move      P#LNRF        N1SLNO                                       CSD027
     C                   ENDIF                                                                156295
     C                   ENDIF                                                                146971
      *                                                                                       146971
     C                   ENDIF
      *
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2030'
     C                   PARM                    P#MODE
     C                   PARM      W#MSGT        P#MSGT
     C                   PARM                    N1MFPD
     C                   PARM                    N2MFPD
     C                   PARM                    PTimestamp                                   CLE034
     C/COPY WNCPYSRC,LE2010MC04
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     N2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2030'      DBFILE
     C                   Z-ADD     14            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           N2MSGS                                       209692
     C                   MOVE      'LEX9993'     N2MSGI                                       209692
     C                   MOVE      ERRMSG        N2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           N2MSGS                                       209692
     C                   MOVE      'LEX9994'     N2MSGI                                       209692
     C                   MOVE      ERRMSG        N2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     N2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C*****              Z-ADD     N2LNRF        W#LNRF
      *
     C     N1GPRT        IFEQ      'Y'
     C**********         Z-ADD     N2LNRF        W#TOLN                                       CLE148
     C                   MOVEL     N2LNRF        W#TOLN                                       CLE148
     C                   ELSE
     C**********         Z-ADD     0             W#TOLN                                       CLE148
     C                   MOVEL     *BLANKS       W#TOLN                                       CLE148
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE035
      ** Save Loan Number to a temporary variable                                             CLE035
                                                                                              CLE035
     C                   IF        CLE035 = 'Y'                                               CLE035
     C                   EVAL      WSoldLoan = N2LNRF                                         CLE035
     C                   EVAL      WLastType = W#MSGT                                         CLE035
     C                   ENDIF                                                                CLE035
      *
     C                   MOVEL(P)  N2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LABC'
     C     W#MSGT        OREQ      'LALS'
     C     W#MSGT        OREQ      'LAPI'
     C     W#MSGT        OREQ      'LASA'
     C     W#MSGT        OREQ      'LASC'
     C     W#MSGT        OREQ      'LAPD'                                                     226033
      *                                                                                183967 196224
      **If*the*Loan*Amendment's*loan*number*is*blank*then*it*was                       183967 196224
      **generated*as*the*result*of*an*Assignment*to*a*new*participant                  183967 196224
      **hence*a*Principal*Increase*for*the*corresponding*new*Partsold.                 183967 196224
      **Add*the*new*partsold's*loan*number*to*the*Loan*Amendments's                    183967 196224
      **loan*number*field.*Note*-*the*PI*would*have*been*generated*as*a                183967 196224
      **result*of*a*second*Assignment*to*the*new*Partsold*in*the*same                  183967 196224
      **batch*as*the*first.*The*new*Partsold's*Amount*would*reflect*the                183967 196224
      **first*Assignment,*the*PI*reflects*the*second.                                  183967 196224
      *******************                                                              183967 196224
     C*****W#MSGT        IFEQ      'LAPI'                                              183967 196224
     C*****A1LNRF        ANDEQ     0                                                   183967 196224
     C*****A1ACTN        ANDEQ     'I'                                                 183967 196224
     C*******************ADD       N2LNRF        A1LNRF                                183967 196224
     C*******************ENDIF                                                         183967 196224
      *
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(OVR_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      OVR_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
      *                                                                                       CAP061
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2040'
     C                   PARM                    P#MODE
     C                   PARM                    A1MFPD
     C                   PARM                    A2MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP061
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(DLT_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      DLT_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     A2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2040'      DBFILE
     C                   Z-ADD     15            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9993'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9994'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     A2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  A2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LAPT'
      *
      **  Set loan number
     C*****A1LNRF        IFEQ      0                                                          CLE148
     C**********         Z-ADD     W#TOLN        A1LNRF                                       CLE148
     C     A1LNRF        IFEQ      *BLANKS                                                    CLE148
     C                   MOVEL     W#TOLN        A1LNRF                                       CLE148
     C                   ENDIF
      *
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(OVR_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      OVR_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
      *                                                                                       CAP061
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2040'
     C                   PARM                    P#MODE
     C                   PARM                    A1MFPD
     C                   PARM                    A2MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP061
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(DLT_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      DLT_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     A2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2040'      DBFILE
     C                   Z-ADD     16            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9993'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9994'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     A2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
      **  Set transfer to Sequence to value from return message
     C     *LIKE         DEFINE    A2ROSN        W#TTSQ
     C*****              Z-ADD     A2ROSN        W#TTSQ                                       144096
     C                   Z-ADD     A2LASN        W#TTSQ                                       144096
      *
      **  Save return mesage
     C                   MOVE      A2MFPD        A3MFPD
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LAPF'
      *
     C*****A1ROLN        IFEQ      0                                                          CLE148
     C**********         Z-ADD     W#TOLN        A1ROLN                                       CLE148
     C     A1ROLN        IFEQ      *BLANKS                                                    CLE148
     C                   MOVEL     W#TOLN        A1ROLN                                       CLE148
     C                   ENDIF
      *
     C     A1ROSN        IFEQ      0
     C                   Z-ADD     W#TTSQ        A1ROSN
     C                   ENDIF
      *
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(OVR_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      OVR_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
      *                                                                                       CAP061
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2040'
     C                   PARM                    P#MODE
     C                   PARM                    A1MFPD
     C                   PARM                    A2MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP061
     C     CAP061        IFEQ      'Y'                                                        CAP061
     C                   EVAL      LENGTH = %SIZE(DLT_LEILAMLX)                               CAP061
     C                   CALL      'QCMDEXC'                                                  CAP061
     C                   PARM      DLT_LEILAMLX  QCMD                                         CAP061
     C                   PARM                    LENGTH                                       CAP061
     C                   ENDIF                                                                CAP061
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     A2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2040'      DBFILE
     C                   Z-ADD     17            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9993'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           A2MSGS                                       209692
     C                   MOVE      'LEX9994'     A2MSGI                                       209692
     C                   MOVE      ERRMSG        A2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     A2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
      **  Set transfer from Sequence to value from return message
     C     *LIKE         DEFINE    A2ROSN        W#TFSQ
     C                   Z-ADD     A2ROSN        W#TFSQ
     C                   MOVE      A2MFPD        A4MFPD
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'ROLL'
      *
     C     CAP062        IFEQ      'Y'                                                        CAP062
     C                   EVAL      LENGTH = %SIZE(OVR_LEIROLLX)                               CAP062
     C                   CALL      'QCMDEXC'                                                  CAP062
     C                   PARM      OVR_LEIROLLX  QCMD                                         CAP062
     C                   PARM                    LENGTH                                       CAP062
     C                   ENDIF                                                                CAP062
      *                                                                                       CAP062
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2070'
     C                   PARM                    P#MODE
     C                   PARM      W#MSGT        P#MSGT
     C                   PARM                    O1MFPD
     C                   PARM                    O2MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP062
     C     CAP062        IFEQ      'Y'                                                        CAP062
     C                   EVAL      LENGTH = %SIZE(DLT_LEIROLLX)                               CAP062
     C                   CALL      'QCMDEXC'                                                  CAP062
     C                   PARM      DLT_LEIROLLX  QCMD                                         CAP062
     C                   PARM                    LENGTH                                       CAP062
     C                   ENDIF                                                                CAP062
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     O2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2070'      DBFILE
     C                   Z-ADD     18            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           O2MSGS                                       209692
     C                   MOVE      'LEX9993'     O2MSGI                                       209692
     C                   MOVE      ERRMSG        O2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           O2MSGS                                       209692
     C                   MOVE      'LEX9994'     O2MSGI                                       209692
     C                   MOVE      ERRMSG        O2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     O2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  O2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LAMR'
      *
     C*****M1LNRF        IFEQ      0                                                   147902 CLE148
     C**********         Z-ADD     P#LNRF        M1LNRF                                147902 CLE148
     C     M1LNRF        IFEQ      *BLANKS                                                    CLE148
     C                   MOVEL     P#LNRF        M1LNRF                                       CLE148
     C                   ENDIF                                                                147902
      *                                                                                       147902
     C     CAP063        IFEQ      'Y'                                                        CAP063
     C                   EVAL      LENGTH = %SIZE(OVR_LEIMRPLX)                               CAP063
     C                   CALL      'QCMDEXC'                                                  CAP063
     C                   PARM      OVR_LEIMRPLX  QCMD                                         CAP063
     C                   PARM                    LENGTH                                       CAP063
     C                   ENDIF                                                                CAP063
      *                                                                                       CAP063
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2110'
     C                   PARM                    P#MODE
     C                   PARM                    M1MFPD
     C                   PARM                    M2MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP063
     C     CAP063        IFEQ      'Y'                                                        CAP063
     C                   EVAL      LENGTH = %SIZE(DLT_LEIMRPLX)                               CAP063
     C                   CALL      'QCMDEXC'                                                  CAP063
     C                   PARM      DLT_LEIMRPLX  QCMD                                         CAP063
     C                   PARM                    LENGTH                                       CAP063
     C                   ENDIF                                                                CAP063
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     M2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C*****              MOVEL     'LE2070'      DBFILE
     C                   MOVEL     'LE2110'      DBFILE
     C                   Z-ADD     19            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           M2MSGS                                       209692
     C                   MOVE      'LEX9993'     M2MSGI                                       209692
     C                   MOVE      ERRMSG        M2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           M2MSGS                                       209692
     C                   MOVE      'LEX9994'     M2MSGI                                       209692
     C                   MOVE      ERRMSG        M2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     M2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  M2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'LARE'
      *
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2120'
     C                   PARM                    P#MODE
     C                   PARM                    P1MFPD
     C                   PARM                    P2MFPD
     C                   PARM                    PTimestamp                                   CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     P2MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C*****              MOVEL     'LE2070'      DBFILE
     C                   MOVEL     'LE2120'      DBFILE
     C                   Z-ADD     20            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           P2MSGS                                       209692
     C                   MOVE      'LEX9993'     P2MSGI                                       209692
     C                   MOVE      ERRMSG        P2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           P2MSGS                                       209692
     C                   MOVE      'LEX9994'     P2MSGI                                       209692
     C                   MOVE      ERRMSG        P2MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     P2MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  P2MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'FEES'
     C     CLE005        ANDEQ     'Y'
      *
     C     W#PCNO        IFNE      0                                                          132762
     C                   MOVE      W#PCNO        F3FCNO                                       132762
     C                   ENDIF                                                                132762
      *                                                                                       132762
     C                   EVAL      LENGTH = %SIZE(OVRDBF)                                     134390
     C                   CALL      'QCMDEXC'                                                  134390
     C                   PARM      OVRDBF        QCMD                                         134390
     C                   PARM                    LENGTH                                       134390
      *                                                                                       134390
     C                   EVAL      LENGTH = %SIZE(OVR_LEFEED)                                 149199
     C                   CALL      'QCMDEXC'                                                  149199
     C                   PARM      OVR_LEFEED    QCMD                                         149199
     C                   PARM                    LENGTH                                       149199
      *                                                                                       CAP064
     C     CAP064        IFEQ      'Y'                                                        CAP064
     C                   EVAL      LENGTH = %SIZE(OVR_LEIFEELX)                               CAP064
     C                   CALL      'QCMDEXC'                                                  CAP064
     C                   PARM      OVR_LEIFEELX  QCMD                                         CAP064
     C                   PARM                    LENGTH                                       CAP064
     C                   ENDIF                                                                CAP064
      *                                                                                       134390
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2210'
     C                   PARM                    P#MODE
     C                   PARM                    F3MFPD
     C                   PARM                    F4MFPD
     C                   PARM                    PTimestamp                                   CLE034
      *                                                                                       CAP064
     C     CAP064        IFEQ      'Y'                                                        CAP064
     C                   EVAL      LENGTH = %SIZE(DLT_LEIFEELX)                               CAP064
     C                   CALL      'QCMDEXC'                                                  CAP064
     C                   PARM      DLT_LEIFEELX  QCMD                                         CAP064
     C                   PARM                    LENGTH                                       CAP064
     C                   ENDIF                                                                CAP064
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     F4MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2210'      DBFILE
     C                   Z-ADD     21            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           F4MSGS                                       209692
     C                   MOVE      'LEX9993'     F4MSGI                                       209692
     C                   MOVE      ERRMSG        F4MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           F4MSGS                                       209692
     C                   MOVE      'LEX9994'     F4MSGI                                       209692
     C                   MOVE      ERRMSG        F4MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C                   ELSE
      *
     C     F4MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  F4MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
                                                                                              CLE035
      ** Save Fee Sequence to a temporary variable                                            CLE035
                                                                                              CLE035
     C                   IF        CLE035 = 'Y'                                               CLE035
     C                   MOVE      F4SEQR        WFeeSeq                                      CLE035
     C                   ENDIF                                                                CLE035
      *
      **
      *
     C     W#MSGT        WHENEQ    'FSET'
     C     CLE005        ANDEQ     'Y'
      *
     C                   IF        CLE034 = 'Y'                                               CLE034
     C**********                   AND WStAlocUsed = 'Y'                               CLE034 227708
     C                   IF        WStAlocUsed = 'Y'                                          227708
                                                                                              CLE034
     C                   IF        WrkSA1TMS <> WDefaultTS                                    CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   EVAL      WStAlocProc = 'Y'                                          CLE034
                                                                                              CLE034
     C                   ELSE                                                                 227708
     C                   EVAL      PTimestamp = WDefaultTS                                    227708
     C                   ENDIF                                                                227708
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(OVR_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      OVR_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LE2220'
     C                   PARM                    P#MODE
     C                   PARM      'S'           P#FTYP            1
     C                   PARM                    F5MFPD
     C                   PARM                    F6MFPD
     C                   PARM                    PTimestamp                                   CLE034
                                                                                              CLE034
     C     CLE034        IFEQ      'Y'                                                        CLE034
     C                   EVAL      LENGTH = %SIZE(DLT_LESTALLX)                               CLE034
     C                   CALL      'QCMDEXC'                                                  CLE034
     C                   PARM      DLT_LESTALLX  QCMD                                         CLE034
     C                   PARM                    LENGTH                                       CLE034
     C                   ENDIF                                                                CLE034
      *
     C     F6MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2220'      DBFILE
     C                   Z-ADD     22            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           F6MSGS                                       209692
     C                   MOVE      'LEX9993'     F6MSGI                                       209692
     C                   MOVE      ERRMSG        F6MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           F6MSGS                                       209692
     C                   MOVE      'LEX9994'     F6MSGI                                       209692
     C                   MOVE      ERRMSG        F6MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     F6MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
                                                                                              CLE034
     C                   IF        CLE034 = 'Y'                                               CLE034
     C                   EVAL      WStAlocUsed = *BLANKS                                      CLE034
     C                   EVAL      WStAlocProc = *BLANKS                                      CLE034
     C                   EVAL      W1stMsgInd = 'Y'                                           CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   MOVEL(P)  F6MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      **
      *
     C     W#MSGT        WHENEQ    'FAFD'
     C     CLE005        ANDEQ     'Y'
     C     W#MSGT        OREQ      'FAFI'
     C     CLE005        ANDEQ     'Y'
     C     W#MSGT        OREQ      'FAFR'
     C     CLE005        ANDEQ     'Y'
     C     W#MSGT        OREQ      'FARC'
     C     CLE005        ANDEQ     'Y'
      *
     C     W#PCNO        IFNE      0                                                          157907
     C                   MOVE      W#PCNO        A5FCNO                                       157907
     C                   ENDIF                                                                157907
      *
     C                   EVAL      LENGTH = %SIZE(OVR_LEFCAMSQ)                               202546
     C                   CALL      'QCMDEXC'                                                  202546
     C                   PARM      OVR_LEFCAMSQ  QCMD                                         202546
     C                   PARM                    LENGTH                                       202546
      *                                                                                       202546
     C                   CALL      'LE2150'
     C                   PARM                    P#MODE
     C*****              PARM                    A5MFPD          161
     C*****              PARM                    A6MFPD          185
     C                   PARM                    A5MFPD
     C                   PARM                    A6MFPD
      *                                                                                       202546
     C                   EVAL      LENGTH = %SIZE(DLT_LEFCAMSQ)                               202546
     C                   CALL      'QCMDEXC'                                                  202546
     C                   PARM      DLT_LEFCAMSQ  QCMD                                         202546
     C                   PARM                    LENGTH                                       202546
      *
     C     A6MSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'LE2150'      DBFILE
     C                   Z-ADD     23            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
      *
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           F6MSGS                                       209692
     C                   MOVE      'LEX9993'     F6MSGI                                       209692
     C                   MOVE      ERRMSG        F6MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           F6MSGS                                       209692
     C                   MOVE      'LEX9994'     F6MSGI                                       209692
     C                   MOVE      ERRMSG        F6MSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     A6MSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C                   MOVEL(P)  A6MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *                                                                                       CLE011
     C     W#MSGT        WHENEQ    'RTFX'                                                     CLE011
     C     CLE011        ANDEQ     'Y'                                                        CLE011
      *                                                                                       CLE011
     C                   CALL      'LE2165'                                                   CLE011
     C                   PARM                    P#MODE                                       CLE011
     C                   PARM                    PLoan                                        CLE011
     C                   PARM                    O3MFPD                                       CLE011
     C                   PARM                    O4MFPD                                       CLE011
                                                                                              CLE034
     C                   WHEN      CLE034 = 'Y'                                               CLE034
     C                             AND W#MSGT = 'STAL'                                        CLE034
                                                                                              CLE034
     C                   IF        W1stMsgInd = 'N'                                           CLE034
                                                                                              CLE034
     C                   EVAL      PTimestamp = WrkSA1TMS                                     CLE034
                                                                                              CLE034
     C                   ELSE                                                                 CLE034
     C                   EVAL      PTimestamp = WDefaultTS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   CALL      'LEC2240'                                                  CLE034
     C                   PARM                    P#MODE                                       CLE034
     C                   PARM                    SA1MPD                                       CLE034
     C                   PARM                    SA2MPD                                       CLE034
     C                   PARM                    PTimestamp                                   CLE034
                                                                                              CLE034
     C                   IF        SA2MGS = 'D'                                               CLE034
                                                                                              CLE034
     C                   MOVEL     '*CALL'       DBKEY                                        CLE034
     C                   MOVEL     'LE2240'      DBFILE                                       CLE034
     C                   Z-ADD     35            DBASE                                        CLE034
     C                   MOVE      'Y'           W#ERROR                                      CLE034
     C                   EXSR      *PSSR                                                      CLE034
                                                                                              CLE034
     C                   ELSE                                                                 CLE034
                                                                                              CLE034
     C                   IF        SA2MGS = 'E'                                               CLE034
     C                   MOVE      'Y'           W#ERROR                                      CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   IF        W1stMsgInd = 'Y'                                           CLE034
     C                   MOVEL     SA1TMS        WrkSA1TMS                                    CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
     C                   MOVE      'N'           W1stMsgInd                                   CLE034
     C                   EVAL      WStAlocUsed = 'Y'                                          CLE034
     C                   MOVEL(P)  SA2MPD        W#RMSG
     C                   EXSR      PUTMSG                                                     CLE034
                                                                                              CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE034
      ** Processing for Income Splits                                                         CLE035
                                                                                              CLE035
     C                   WHEN      W#MSGT = 'TISP' AND CLE035 = 'Y'                           CLE035
                                                                                              CLE035
     C**********         IF        I1CNUM <> 0                                        CLE035 CSD027A
     C                   IF        I1CNUM <> *Blanks                                         CSD027A
                                                                                              CLE035
      ** A Fee is being Processed                                                             CLE035
                                                                                              CLE035
     C                   EVAL      POption = 'F'                                              CLE035
     C                   IF        I1FESQ = 0                                                 CLE035
     C                   EVAL      I1FESQ = WFeeSeq                                           CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
      ** A Loan is Being Processsed                                                           CLE035
                                                                                              CLE035
     C                   EVAL      POption = 'L'                                              CLE035
     C**********         IF        I1LNRF = 0                                          CLE035 CLE148
     C                   IF        I1LNRF = *BLANKS                                           CLE148
                                                                                              CLE035
     C                   SELECT                                                               CLE035
                                                                                              CLE035
     C                   WHEN      WLastType = 'PTPU'                                         CLE035
     C                   EVAL      I1LNRF = P#LNRF                                            CLE035
                                                                                              CLE035
     C                   WHEN      WLastType = 'PTSO'                                         CLE035
     C                   EVAL      I1LNRF = WSoldLoan                                         CLE035
                                                                                              CLE035
     C                   OTHER                                                                CLE035
     C                   EVAL      I1LNRF = W#LNRF                                            CLE035
                                                                                              CLE035
     C                   ENDSL                                                                CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
      ** Issue Overrides                                                                      CLE035
                                                                                              CLE035
     C                   EVAL      LENGTH = %SIZE(OVR_LETISPLX)                               CLE035
     C                   CALL      'QCMDEXC'                                                  CLE035
     C                   PARM      OVR_LETISPLX  QCMD                                         CLE035
     C                   PARM                    LENGTH                                       CLE035
                                                                                              CLE035
     C                   EVAL      LENGTH = %SIZE(OVR_LETISPLY)                               CLE035
     C                   CALL      'QCMDEXC'                                                  CLE035
     C                   PARM      OVR_LETISPLY  QCMD                                         CLE035
     C                   PARM                    LENGTH                                       CLE035
                                                                                              CLE035
     C                   EVAL      LENGTH = %SIZE(OVR_LETISPLV)                               CLE035
     C                   CALL      'QCMDEXC'                                                  CLE035
     C                   PARM      OVR_LETISPLV  QCMD                                         CLE035
     C                   PARM                    LENGTH                                       CLE035
                                                                                              CLE035
     C                   EVAL      LENGTH = %SIZE(OVR_LETISPLW)                               CLE035
     C                   CALL      'QCMDEXC'                                                  CLE035
     C                   PARM      OVR_LETISPLW  QCMD                                         CLE035
     C                   PARM                    LENGTH                                       CLE035
                                                                                              CLE035
     C                   CALL      'LE2080'                                                   CLE035
      ** Mode - B for Batch Processing                                                        CLE035
      ** Option - 'L' for Loan, 'F' for Fee                                                   CLE035
      ** Input Data Structure                                                                 CLE035
      ** Output Data Structure                                                                CLE035
     C                   PARM                    P#MODE                                       CLE035
     C                   PARM                    POption                                      CLE035
     C                   PARM                    I1MFPD                                       CLE035
     C                   PARM                    I2MFPD                                       CLE035
                                                                                              CLE035
     C                   IF        I2MSGS = 'D'                                               CLE035
     C                   MOVEL     '*CALL'       DBKEY                                        CLE035
     C                   MOVEL     'LE2080'      DBFILE                                       CLE035
     C                   Z-ADD     36            DBASE                                        CLE035
     C                   MOVE      'Y'           W#ERROR                                      CLE035
     C                   EXSR      *PSSR                                                      CLE035
                                                                                              CLE035
     C                   ELSE                                                                 CLE035
                                                                                              CLE035
     C                   IF        I2MSGS = 'E'                                               CLE035
     C                   EVAL      W#ERROR = 'Y'                                              CLE035
     C                   ENDIF                                                                CLE035
                                                                                              CLE035
     C                   EVAL      W#RMSG = I2MFPD                                            CLE035
     C                   EXSR      PUTMSG                                                     CLE035
                                                                                              CLE035
     C                   ENDIF                                                                CLE035
      *
      **
      *
     C     W#MSGT        WHENNE    'FCTY'
     C     W#MSGT        ANDNE     'FCFP'
     C     W#MSGT        ANDNE     'FCRP'
     C     W#MSGT        ANDNE     'FCAS'
     C     W#MSGT        ANDNE     'LOAN'
     C     W#MSGT        ANDNE     'PTPU'
     C     W#MSGT        ANDNE     'PTSO'
     C     W#MSGT        ANDNE     'LABC'
     C     W#MSGT        ANDNE     'LALS'
     C     W#MSGT        ANDNE     'LAPI'
     C     W#MSGT        ANDNE     'LASA'
     C     W#MSGT        ANDNE     'LASC'
     C     W#MSGT        ANDNE     'LAPF'
     C     W#MSGT        ANDNE     'LAPT'
     C     W#MSGT        ANDNE     'LAMR'
     C     W#MSGT        ANDNE     'LARE'
     C     W#MSGT        ANDNE     'LAPD'                                                     226033
     C     W#MSGT        ANDNE     'ROLL'
     C     W#MSGT        ANDNE     'FEES'
     C     W#MSGT        ANDNE     'FSET'
     C     W#MSGT        ANDNE     'FAFD'
     C     W#MSGT        ANDNE     'FAFI'
     C     W#MSGT        ANDNE     'FAFR'
     C     W#MSGT        ANDNE     'FARC'
     C     W#MSGT        ANDNE     'RTFX'                                                     CLE011
     C     W#MSGT        ANDNE     'STAL'                                                     CLE034
     C     W#MSGT        ANDNE     'TISP'                                                     CLE035
      *
      **  Determine if CLE005 is ON
      *
     C     CLE005        IFEQ      'Y'
     C     W#MSGT        ANDNE     'FCTY'
     C     W#MSGT        ANDNE     'FCFP'
     C     W#MSGT        ANDNE     'FCRP'
     C     W#MSGT        ANDNE     'FCAS'
     C     W#MSGT        ANDNE     'LOAN'
     C     W#MSGT        ANDNE     'PTPU'
     C     W#MSGT        ANDNE     'PTSO'
     C     W#MSGT        ANDNE     'LABC'
     C     W#MSGT        ANDNE     'LALS'
     C     W#MSGT        ANDNE     'LAPI'
     C     W#MSGT        ANDNE     'LASA'
     C     W#MSGT        ANDNE     'LASC'
     C     W#MSGT        ANDNE     'LAPF'
     C     W#MSGT        ANDNE     'LAPT'
     C     W#MSGT        ANDNE     'LAMR'
     C     W#MSGT        ANDNE     'LARE'
     C     W#MSGT        ANDNE     'LAPD'                                                     226033
     C     W#MSGT        ANDNE     'ROLL'
     C     W#MSGT        ANDNE     'FEES'
     C     W#MSGT        ANDNE     'FSET'
     C     W#MSGT        ANDNE     'FAFD'
     C     W#MSGT        ANDNE     'FAFI'
     C     W#MSGT        ANDNE     'FAFR'
     C     W#MSGT        ANDNE     'FARC'
      *
     C     CLE005        OREQ      'N'
     C     W#MSGT        ANDNE     'FCTY'
     C     W#MSGT        ANDNE     'FCFP'
     C     W#MSGT        ANDNE     'FCAS'
     C     W#MSGT        ANDNE     'LOAN'
     C     W#MSGT        ANDNE     'PTPU'
     C     W#MSGT        ANDNE     'PTSO'
     C     W#MSGT        ANDNE     'LABC'
     C     W#MSGT        ANDNE     'LALS'
     C     W#MSGT        ANDNE     'LAPI'
     C     W#MSGT        ANDNE     'LASA'
     C     W#MSGT        ANDNE     'LASC'
     C     W#MSGT        ANDNE     'LAPF'
     C     W#MSGT        ANDNE     'LAPT'
     C     W#MSGT        ANDNE     'LAMR'
     C     W#MSGT        ANDNE     'LARE'
     C     W#MSGT        ANDNE     'LAPD'                                                     226033
     C     W#MSGT        ANDNE     'ROLL'
      *
      **
     C     *LIKE         DEFINE    DLWNCN        W#WNCN
     C     *LIKE         DEFINE    DLLGWD        W#LGWD
     C     *LIKE         DEFINE    DLWDWD        W#WDWD
     C     *LIKE         DEFINE    DLTTWD        W#TTWD
     C     *LIKE         DEFINE    DLSRWD        W#SRWD
     C     *LIKE         DEFINE    DLSCWD        W#SCWD
     C                   MOVE      *BLANKS       W#WNCN
      *
      **  Access the Mandatory Window by message type
     C     W#MSGT        CHAIN     SDMREFL2                           80
      *
     C     *IN80         IFEQ      *OFF
      *
     C                   MOVE      DLWNCN        W#WNCN
     C                   MOVE      DLLGWD        W#LGWD
     C                   MOVE      DLWDWD        W#WDWD
     C                   MOVE      DLTTWD        W#TTWD
     C                   MOVE      DLSRWD        W#SRWD
     C                   MOVE      DLSCWD        W#SCWD
      *
     C                   ELSE
      *
      **  Access the Optional Window by message type
     C     W#MSGT        CHAIN     SDOREFL2                           80
      *
     C     *IN80         IFEQ      *OFF
      *
     C                   MOVE      DMWNCN        W#WNCN
     C                   MOVE      DMLGWD        W#LGWD
     C                   MOVE      DMWDWD        W#WDWD
     C                   MOVE      DMTTWD        W#TTWD
     C                   MOVE      DMSRWD        W#SRWD
     C                   MOVE      DMSCWD        W#SCWD
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     W#MSGT        IFNE      *BLANKS
     C     W#WNCN        ANDNE     *BLANKS
      *
     C                   MOVEL     P#MESSAGE     DATA
      /COPY WNCPYSRC,LE2010C001
      *
     C                   CALL      W#WNCN
     C                   PARM                    P#MODE
     C*****              PARM                    P#MESSAGE
     C                   PARM                    DATA
     C                   PARM      *BLANK        P#RTRN            7
     C                   PARM                    W#LGWD
     C                   PARM                    W#WDWD
     C                   PARM                    W#SRWD
     C                   PARM                    W#SCWD
     C                   PARM                    W#TTWD
     C*****              PARM                    SPARE
     C                   PARM      *BLANKS       SPARE
      *
     C*****W#2025        IFEQ      'D'
     C     WNMSGS        IFEQ      'D'
     C                   MOVEL     '*CALL'       DBKEY
     C                   MOVEL     'W#WNCN'      DBFILE
     C                   Z-ADD     24            DBASE
     C                   MOVE      'Y'           W#ERROR
     C                   EXSR      *PSSR
     C*****              ENDIF
     C                   ELSE
      *                                                                                       209692
      * Flag return message with error if PCRF test failed earlier                            209692
      *                                                                                       209692
     C     RTCODE        IFEQ      'DUPLICATE'                                                209692
     C                   MOVE      'E'           WNMSGS                                       209692
     C                   MOVE      'LEX9993'     WNMSGI                                       209692
     C                   MOVE      ERRMSG        WNMSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     RTCODE        IFEQ      'INVALID  '                                                209692
     C                   MOVE      'E'           WNMSGS                                       209692
     C                   MOVE      'LEX9994'     WNMSGI                                       209692
     C                   MOVE      ERRMSG        WNMSTX                                       209692
     C                   ENDIF                                                                209692
      *
     C     WNMSGS        IFEQ      'E'
     C                   MOVE      'Y'           W#ERROR
     C                   ENDIF
      *
     C*****              MOVEL(P)  W#2025        W#RMSG
     C                   MOVEL(P)  SPARE         W#RMSG
     C                   EXSR      PUTMSG
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'E'           W#MSSS
     C                   MOVE      'LEX9998'     W#MSSD
     C                   MOVEL     'LEX9998'     ZAMSID
     C                   MOVEL     'LERMSGF'     ZAMSGF
      *
     C                   CALL      'Y2RVMGC'
     C                   PARM                    W0RTN             7
     C                   PARM                    ZAMSID            7
     C                   PARM                    ZAMSGF           10
     C                   PARM                    ZAMSDAT         132
     C                   PARM                    ZAMSTX          132
      *
     C                   MOVEL     ZAMSTX        W#MSSX
     C                   MOVEL     P#MESSAGE     W#FST80
     C                   MOVEL(P)  INVMSG        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   ENDIF
      *
      *
     C                   ENDIF
      *
     C                   ENDSL
      *
      *
     C     W#MSGT        IFEQ      'LAPF'
     C     A3MFPD        ANDNE     *BLANKS
     C     A4MFPD        ANDNE     *BLANKS
      *
     C     W#TTSQ        IFEQ      0
     C                   Z-ADD     W#TFSQ        A3ROSN
     C                   ENDIF
      *
     C                   MOVEL(P)  A3MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C     W#TFSQ        IFEQ      0
     C                   Z-ADD     W#TTSQ        A4ROSN
     C                   ENDIF
      *
     C                   MOVEL(P)  A4MFPD        W#RMSG
     C                   EXSR      PUTMSG
      *
     C                   MOVE      *BLANKS       A3MFPD
     C                   Z-ADD     0             W#TFSQ
     C                   MOVE      *BLANKS       A4MFPD
     C                   Z-ADD     0             W#TTSQ
      *
     C                   ENDIF
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Process put message
      **********************************************************************
     C     PUTMSG        BEGSR
      *
      **  Put message
     C                   MOVEL     A8MQRT        ODON
      *
      **  Report Options: no report required
     C                   Z-ADD     RONONE        MDREP
      *
      **  Specify that Format name consists entirely of characters
     C                   MOVEL     FMSTR         MDFMT
      *
      **  Message Type: message not requiring a reply
     C                   Z-ADD     MTDGRM        MDMT
      *
      **  Message Priority: default priority
     C                   Z-ADD     PRQDEF        MDPRI
      *
      **  Message Persistence: message is persistent
     C                   Z-ADD     PEQDEF        MDPER
      *
      **  syncpoint control
     C                   Z-ADD     PMSYP         PMOPT
      *
      **  Set correlation ID.
     C                   MOVE      W#MDCID       MDCID
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQPUT         P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM      W#ROBJH       P#HOBJ            9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQPMO                                      MD041126
     C**********         PARM      W#MLEN        P#MLEN            9 0                      MD041126
     C**********         PARM                    W#RMSG                                     MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     W#ROBJH       P#HOBJ                                     MD041126
     C                   Z-ADD     W#MLEN        P#MLEN                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQPUT( P#HCONN : P#HOBJ :                                MD041126
     C                                    MQMD : MQPMO : P#MLEN :                           MD041126
     C                                    %ADDR(W#RMSG) : P#CCODE :                         MD041126
     C                                    P#REASON )                                        MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQPUT failed
     C     P#CCODE       IFNE      CCOK
     C**********         MOVEL     MQPUT         DBKEY                                      MD041126
     C                   MOVEL     'MQPUT'       DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     25            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Write a record to file LEBRMSPD
     C                   MOVEL     W#RMSG        BRRMSG
     C                   WRITE     LEBRMSD0
      *
     C                   ENDSR
      /EJECT
      **********************************************************************
      *  Initialisation
      **********************************************************************
     C     INITPR        BEGSR
      *
      **  Set up copyright parameter
     C                   MOVEA     CPY@          MKI@             80
      *
      **  Set up program name
     C                   MOVEL     ##PGM         DBPGM
      *
      **  Access Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG'        W@RTCD            7
     C                   PARM      '*FIRST'      W@OPTN            7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     W@RTCD        IFNE      *BLANKS
     C                   MOVEL     '*FIRST'      DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   Z-ADD     26            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      **  Check if SAR CLE005 is installed
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       W@RTCD            7
     C                   PARM      '*KEY   '     W@OPTN            7
     C                   PARM      'CLE005'      W@SARD            6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     W@RTCD        IFEQ      *BLANKS
     C                   MOVE      'Y'           CLE005            1
     C                   ELSE
     C                   MOVE      'N'           CLE005
     C                   ENDIF
      *                                                                                       CLE011
      ** Check if Rollover Rate Fixng Day Enhancement (CLE011) is installed                   CLE011
      *                                                                                       CLE011
     C                   CALL      'AOSARDR0'                                                 CLE011
     C                   PARM      *BLANKS       W@RTCD                                       CLE011
     C                   PARM      '*KEY   '     W@OPTN                                       CLE011
     C                   PARM      'CLE011'      W@SARD                                       CLE011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE011
      *                                                                                       CLE011
     C                   IF        W@RTCD = *BLANKS                                           CLE011
     C                   MOVE      'Y'           CLE011            1                          CLE011
     C                   ELSE                                                                 CLE011
     C                   MOVE      'N'           CLE011                                       CLE011
     C                   IF        W@RTCD <> '*NRF   '                                        CLE011
     C                   MOVEL     'CLE011'      DBKEY                                        CLE011
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE011
     C                   Z-ADD     33            DBASE                                        CLE011
     C                   EXSR      *PSSR                                                      CLE011
     C                   ENDIF                                                                CLE011
     C                   ENDIF                                                                CLE011
      *                                                                                       CAP053
      **  Check if SAR CAP053 is installed                                                    CAP053
      *                                                                                       CAP053
     C                   CALL      'AOSARDR0'                                                 CAP053
     C                   PARM      *BLANKS       W@RTCD                                       CAP053
     C                   PARM      '*KEY   '     W@OPTN                                       CAP053
     C                   PARM      'CAP053'      W@SARD                                       CAP053
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP053
      *                                                                                       CAP053
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP053
     C                   MOVE      'Y'           CAP053            1                          CAP053
     C                   ELSE                                                                 CAP053
     C                   MOVE      'N'           CAP053                                       CAP053
     C                   ENDIF                                                                CAP053
      *                                                                                       CAP061
      **  Check if SAR CAP061 is installed                                                    CAP061
      *                                                                                       CAP061
     C                   CALL      'AOSARDR0'                                                 CAP061
     C                   PARM      *BLANKS       W@RTCD                                       CAP061
     C                   PARM      '*KEY   '     W@OPTN                                       CAP061
     C                   PARM      'CAP061'      W@SARD                                       CAP061
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP061
      *                                                                                       CAP061
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP061
     C                   MOVE      'Y'           CAP061            1                          CAP061
     C                   ELSE                                                                 CAP061
     C                   MOVE      'N'           CAP061                                       CAP061
     C                   ENDIF                                                                CAP061
      *                                                                                       CAP062
      **  Check if SAR CAP062 is installed                                                    CAP062
      *                                                                                       CAP062
     C                   CALL      'AOSARDR0'                                                 CAP062
     C                   PARM      *BLANKS       W@RTCD                                       CAP062
     C                   PARM      '*KEY   '     W@OPTN                                       CAP062
     C                   PARM      'CAP062'      W@SARD                                       CAP062
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP062
      *                                                                                       CAP062
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP062
     C                   MOVE      'Y'           CAP062            1                          CAP062
     C                   ELSE                                                                 CAP062
     C                   MOVE      'N'           CAP062                                       CAP062
     C                   ENDIF                                                                CAP062
      *                                                                                       CAP063
      **  Check if SAR CAP063 is installed                                                    CAP063
      *                                                                                       CAP063
     C                   CALL      'AOSARDR0'                                                 CAP063
     C                   PARM      *BLANKS       W@RTCD                                       CAP063
     C                   PARM      '*KEY   '     W@OPTN                                       CAP063
     C                   PARM      'CAP063'      W@SARD                                       CAP063
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP063
      *                                                                                       CAP063
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP063
     C                   MOVE      'Y'           CAP063            1                          CAP063
     C                   ELSE                                                                 CAP063
     C                   MOVE      'N'           CAP063                                       CAP063
     C                   ENDIF                                                                CAP063
      *                                                                                       CAP064
      **  Check if SAR CAP064 is installed                                                    CAP064
      *                                                                                       CAP064
     C                   CALL      'AOSARDR0'                                                 CAP064
     C                   PARM      *BLANKS       W@RTCD                                       CAP064
     C                   PARM      '*KEY   '     W@OPTN                                       CAP064
     C                   PARM      'CAP064'      W@SARD                                       CAP064
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP064
      *                                                                                       CAP064
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP064
     C                   MOVE      'Y'           CAP064            1                          CAP064
     C                   ELSE                                                                 CAP064
     C                   MOVE      'N'           CAP064                                       CAP064
     C                   ENDIF                                                                CAP064
      *                                                                                       CAP065
      **  Check if SAR CAP065 is installed                                                    CAP065
      *                                                                                       CAP065
     C                   CALL      'AOSARDR0'                                                 CAP065
     C                   PARM      *BLANKS       W@RTCD                                       CAP065
     C                   PARM      '*KEY   '     W@OPTN                                       CAP065
     C                   PARM      'CAP065'      W@SARD                                       CAP065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP065
      *                                                                                       CAP065
     C     W@RTCD        IFEQ      *BLANKS                                                    CAP065
     C                   MOVE      'Y'           CAP065            1                          CAP065
     C                   ELSE                                                                 CAP065
     C                   MOVE      'N'           CAP065                                       CAP065
     C                   ENDIF                                                                CAP065
                                                                                              CLE034
      ** Check if SAR CLE034 is installed                                                     CLE034
                                                                                              CLE034
     C                   CALL      'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       W@RTCD                                       CLE034
     C                   PARM      '*KEY   '     W@OPTN                                       CLE034
     C                   PARM      'CLE034'      W@SARD                                       CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
                                                                                              CLE034
     C     W@RTCD        IFEQ      *BLANKS                                                    CLE034
     C                   MOVE      'Y'           CLE034                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'N'           CLE034                                       CLE034
     C     W@RTCD        IFNE      '*NRF   '                                                  CLE034
     C                   MOVEL     W@SARD        DBKEY                                        CLE034
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE034
     C                   Z-ADD     34            DBASE                                        CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
                                                                                              CLE035
      ** Check if SAR CLE035 is installed                                                     CLE035
                                                                                              CLE035
     C                   CALL      'AOSARDR0'                                                 CLE035
     C                   PARM      *BLANKS       W@RTCD                                       CLE035
     C                   PARM      '*KEY   '     W@OPTN                                       CLE035
     C                   PARM      'CLE035'      W@SARD                                       CLE035
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE035
                                                                                              CLE035
     C     W@RTCD        IFEQ      *BLANKS                                                    CLE035
     C                   MOVE      'Y'           CLE035                                       CLE035
     C                   ELSE                                                                 CLE035
     C                   MOVE      'N'           CLE035                                       CLE035
     C     W@RTCD        IFNE      '*NRF   '                                                  CLE035
     C                   MOVEL     W@SARD        DBKEY                                        CLE035
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CLE035
     C                   Z-ADD     35            DBASE                                        CLE035
     C                   EXSR      *PSSR                                                      CLE035
     C                   ENDIF                                                                CLE035
     C                   ENDIF                                                                CLE035
      *
      **  Access branch details
     C     *LIKE         DEFINE    A8BRCD        W@BRCD
     C*****              CALL      'AOBRCHR0'
     C                   CALL      'AOBRCHR1'
     C                   PARM      '*MSG'        W@RTCD
     C                   PARM      '*KEY'        W@OPTN
     C                   PARM      P#BRANCH      W@BRCD
     C     SDBRCH        PARM      SDBRCH        DSSDY
      *
     C     W@RTCD        IFNE      *BLANKS
     C                   MOVEL     P#BRANCH      DBKEY
     C                   MOVEL     'SDBRCHPD'    DBFILE
     C                   Z-ADD     27            DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *              _______
      **  Attempt to CONNECT to the MQ Manager
      *              ~~~~~~~
     C     *LIKE         DEFINE    P#HCONN       W#HCONN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQCONN        P#CID             9 0                      MD041126
     C**********         PARM      *BLANKS       P#QMNAME         48                        MD041126
     C*****W#HCONN       PARM      *ZERO         P#HCONN           9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   EVAL      P#QMNAME = *BLANKS                                       MD041126
     C                   Z-ADD     *ZERO         P#HCONN                                    MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQCONN( P#QMNAME : P#HCONN :                             MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#HCONN       W#HCONN                                    MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQConnect failed
     C     P#CCODE       IFEQ      CCFAIL
     C**********         MOVEL     MQCONN        DBKEY                                      MD041126
     C                   MOVEL     'MQCONN'      DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     28            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
      *              ____
      **  Attempt to OPEN the MQ Sent Message Queue for the branch
      *              ~~~~
     C     *LIKE         DEFINE    P#HOBJ        W#SOBJH
      *
      **
     C                   MOVEL     A8MQSM        ODON
      *
      **  Object queue manager name: *blank denotes queue manager to
      **  which the application is connected
      *
     C                   CLEAR                   ODMN
      *
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM      MQOPEN        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM      OOINPX        P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#HOBJ            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     OOINPX        P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#HOBJ                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P#HCONN : MQOD :                                 MD041126
     C                                     P#OPTS  : P#HOBJ :                               MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQOPEN failed
      *
     C     P#RSCOD       IFNE      RCNONE
     C**********         MOVEL     MQOPEN        DBKEY                                      MD041126
     C                   MOVEL     'MQOPEN'      DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     29            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     P#HOBJ        W#SOBJH
      *              ____
      **  Attempt to OPEN the MQ Returned Message Queue for the branch
      *              ~~~~
     C     *LIKE         DEFINE    P#HOBJ        W#ROBJH
      *
     C                   MOVEL     A8MQRT        ODON
      *
      **  Object queue manager name: *blank denotes queue manager to
      *   which the application is connected
     C                   CLEAR                   ODMN
      *
     C**********         CALL      'QMQM'                                                   MD041126
      **********                                                                            MD041126
     C**********         PARM      MQOPEN        P#CID             9 0                      MD041126
     C**********         PARM      W#HCONN       P#HCONN           9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM      OOOUT         P#OPTS            9 0                      MD041126
     C**********         PARM      *ZERO         P#HOBJ            9 0                      MD041126
     C**********         PARM      *ZERO         P#CCODE           9 0                      MD041126
     C**********         PARM      *ZERO         P#RSCOD           9 0                      MD041126
                                                                                            MD041126
     C                   Z-ADD     W#HCONN       P#HCONN                                    MD041126
     C                   Z-ADD     OOOUT         P#OPTS                                     MD041126
     C                   Z-ADD     *ZERO         P#HOBJ                                     MD041126
     C                   Z-ADD     *ZERO         P#CCODE                                    MD041126
     C                   Z-ADD     *ZERO         P#REASON                                   MD041126
                                                                                            MD041126
     C                   CALLP     MQOPEN( P#HCONN : MQOD :                                 MD041126
     C                                     P#OPTS  : P#HOBJ :                               MD041126
     C                                     P#CCODE : P#REASON )                             MD041126
                                                                                            MD041126
     C                   Z-ADD     P#REASON      P#RSCOD                                    MD041126
      *
      **  MQOPEN failed
      *
     C     P#RSCOD       IFNE      RCNONE
     C**********         MOVEL     MQOPEN        DBKEY                                      MD041126
     C                   MOVEL     'MQOPEN'      DBKEY                                      MD041126
     C                   MOVEL     'QMQM'        DBFILE
     C                   Z-ADD     30            DBASE
     C                   MOVE      *ON           *IN30
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   Z-ADD     P#HOBJ        W#ROBJH
      *
      *
      **  Set server status data area
     C                   MOVEL     'LEC2010'     W#DTAARA         10
     C                   MOVE      P#SERVER      W#DTAARA
      *
      **  Set W- Return Length
     C                   Z-ADD     256           W#MLEN            3 0
      *
      **  Set  MODE
     C                   MOVE      'B'           P#MODE            1
      *
      **  Open LEBRMSPD
     C                   OPEN      LEBRMSPD
      *
     C                   Z-ADD     0             CLOCK
     C                   Z-ADD     0             MINS
      *
      ** Set flag to submit confirmation job on first cycle of program                        155873
     C                   MOVE      'Y'           SBMCNF            1                          155873
      *                                                                                       155873
     C/COPY WNCPYSRC,LE2010MC01
     C                   ENDSR
      *****************************************************************
      *   Audit File Processing
      *****************************************************************
     C     AUDIT         BEGSR
      *
      **
     C                   OPEN      LE2010AU
      *
      **  Log audit report to RCF
     C                   Z-ADD     SFNUMU        ZSNUM             6 0
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ               5
     C                   PARM      *BLANKS       WPARM             3
     C                   PARM                    SFILEU
     C                   PARM                    ZSNUM
     C                   PARM                    ZSERR             1
     C     ZSERR         IFEQ      'Y'
     C                   SETON                                        U7U8LR
     C                   RETURN
     C                   ENDIF
      *
      * Print Header for Audit Report
     C                   WRITE     HEADAU
      * Print Database Error Details
     C                   WRITE     DBERROR
      *
     C                   ENDSR
      *****************************************************************
      *
      *  *PSSR - Exception error processing
      *      Calls - NONE
      *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      *   If an error has occurred within this program, update LDA, set
      *   error switches, dump program and return to calling program.
      *
     C     @DUMP         IFEQ      *BLANK
      *
      * Audit report required?
     C     DBFILE        IFNE      *BLANKS
     C                   EXSR      AUDIT
     C                   ENDIF
      *
     C     W#ERROR       IFEQ      'Y'
     C                   EXSR      UNITCOMP
     C                   ENDIF
      *
     C                   DUMP
      *
     C                   MOVE      'Y'           @DUMP             1
     C                   SETON                                        U7U8LR
     C     *DTAARA       DEFINE    LDA           @LDA            256
     C     *LOCK         IN        @LDA
     C                   MOVE      DBERR         @LDA
     C                   OUT       @LDA
     C                   ENDIF
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
**  CPY@ - Copyright Statement
(c) Finastra International Limited 2001
