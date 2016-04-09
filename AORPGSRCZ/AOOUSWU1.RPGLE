     H DEBUG
      ********************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AO On-line update of IRS position files')        *
/*OVRF*: OVRDBF FILE(DLPCSCRX) TOFILE(DLPCSCPD)                     : *                       240412
      ********************************************************************
      *                                                                  *
      *  Midas - Access Objects Module                                   *
      *                                                                  *
      *     AOOUSWU1 - On-line Update of Interest Rate Swap Positions    *
      *                files                                             *
      *                                                                  *
      *  (c) Misys International Banking Systems Ltd. 2001               *
      *                                                                  *
      *  Last Amend No. AR1089180          Date 10Oct13               *
      *  Prev Amend No. AR740564           Date 06Jun13               *
      *                 AR812349           Date 23Oct12               *
      *                 AR318276           Date 01Oct12               *
      *                 CLE134             Date 01Aug12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 247544             Date 16May07                  *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240412             Date 02Jul06                  *
      *                 239813             Date 18May06                  *
      *                 CDL038             Date 10May05                  *
      *                 CSD027             Date 09Dec05               *
      *                 BUG8242R           Date 19Oct05               *
      *                 BUG8242            Date 25Aug05               *
      *                 BUG7952            Date 22Jul05                  *
      *                 BUG6373 *CREATE    Date 24Mar05                  *
      *                                                                  *
      *------------------------------------------------------------------*
      *                                                                  *
      *  AR1089180 - Make sure that correct settlement details will   *
      *              be passed. Program should not use -amount in     *
      *              determining pay/receive side. (Child: AR1089181) *
      *            - Applied for MD-22787                             *
      *  AR740564 - No projection for interest adjusment for IRS.     *
      *             (Child: AR740565)                                 *
      *  AR812349 - Incorrect projection of sign for RP and RR deal   *
      *             (Child: AR812350)                                 *
      *  AR318276 - FRA/IRS incorrect mapping of interest by IRS deal.*
      *             Recompile over the changes in /COPY ZCBDYSZ1LE    *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CAP205 - Teller Related APIs - Account Balance Check            *
      *  CAP204 - Teller Related APIs - Account Transfer                 *
      *  247544 - Increase definition of W@NLP2 to match w/ ZINTDYZ2  *
      *           processing as amended by 242286.  (Recompile)       *
      *  240412 - Amendments to Principal Change Schedule do not create  *
      *           new RSACMTPD principal change entries. Apply 236794.   *
      *  239813 - Recompiled to pick up BUG7952 changes in /copy         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                     *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG8272R-Introduced /COPY ZSRSRC,ZDATE9Z2LE, fix for the        *
      *           change in /COPY ZSRSRC,ZCBDYSZ1LE made by CIR013       *
      *  BUG8242- Corrected the parameter length mismatched in ZDATE2    *
      *  BUG7952 - Recompile due to changes in ZSRSRC,ZCBDYSZ1LE         *
      *  BUG6373- Conversion of AOOUSWU0 into ILE                        *
      *                                                                  *
      ********************************************************************
     FDLPCSCL0  IF   E           K DISK
     FDLOLACPD  IF   E           K DISK
     FDLOLCFPD  UF   E           K DISK
     FDLPCSCRX  IF   E           K DISK                                                       240412
     F                                     RENAME(DLPCSCD0:DLPCSCAA)                          240412
     F/COPY WNCPYSRC,AOOUSWU0F1
     D/SPACE 5
     D ZF29            S              5  0 DIM(32) CTDATA PERRCD(14)
     D/SPACE 5
     D*
     D/COPY WNCPYSRC,AOOUSWU0E1
     D**  (Posting) Naratives
     D ##NAR           S             30    DIM(7) CTDATA PERRCD(1)
     D*
     D/COPY WNCPYSRC,AOOUSWU0E2
     D*  Subroutine stack
     D @STK            S             10    DIM(20)
     D*
     D**  Copyright array.
     D/COPY WNCPYSRC,AOOUSWU0E3
     D/SPACE 5
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D** SAR Details Accessed via access program
     D*
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
     D* Dealing details accessed via access program
     D Z#BSTS        E DS                  EXTNAME(Z#BST)
     D Z#ASTS        E DS                  EXTNAME(Z#AST)
     D*
     D Z#WSTS        E DS                  EXTNAME(Z#WST)
     D Z#XSTS        E DS                  EXTNAME(Z#XST)
     D Z#YSTS        E DS                  EXTNAME(Z#YST)
     D Z#ZSTS        E DS                  EXTNAME(Z#ZST)
     D SETIN         E DS                  EXTNAME(DLGXSTPD)
      *
     D/COPY WNCPYSRC,AOOUSWU0I1
     D IRDEAL        E DS                  EXTNAME(DEALSDG)
     D  ##LCD        E                     EXTFLD(LCD)                          ?
     D*
     D ##PAYD          DS
     D  ##PAY                  1      1
     D  ##PAYM                 2      3
     D  ##PAYA                 4     21
     D  ##PAYB                22     24
     D ##RECD          DS
     D  ##REC                  1      1
     D  ##RECM                 2      3
     D  ##RECA                 4     21
     D  ##RECB                22     24
     D ##SETD          DS
      * pay/receive (P/R)
     D  ##PYRC                 1      1
      * settlement method
     D  ##SETM                 2      3
      * settlement account
     D  ##SETA                 4     21
     D  ##NOSN                 4      5
     D  ##ACNO                 4     13
     D  ##CNUM                 4      9
     D  ##ACOD                10     19
     D  ##ACSQ                20     21
      * settlement branch
     D  ##BRCA                22     24
      *
      *  Calling parameter data structure for AOSPOSU0
      *
     D C#DTA           DS           256
      *  Account type N=nostro nbr F=Full nostro G=General Ledger
      *               P=Partial Ledger R= Retail Number  X= no settlement
     D  C#ATYP                 1      1
      *               Full General Ledger - CNUM/CCY/ACOD/ACSQ
     D  C#ACCT                 2     19
     D**C#CNU1**               2      7  0                                                    CSD027
     D  C#CNU1                 2      7                                                       CSD027
     D  C#CCY1                 8     10
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
      *               Nostro number
     D  C#NOSN                 2      3  0
      *               Full Nostro - CCY/NOSN
     D  C#NOS                  2      6
      *               Retail Number
     D  C#ACNO                 2     11  0
      *               Partial Account - CNUM/ACOD/ACSQ
     D**C#CNUM**               2      7  0                                                    CSD027
     D  C#CNUM                 2      7                                                       CSD027
     D  C#ACSQ                12     13  0
      * Branch of account if Partial
     D  C#BRCA                14     16
      * OLPOS Incoming/Outgoing Indicator 'I' or 'O' or ' '
      * on OLPOS update
     D  C#IO                  24     24
      * Currency of transaction
     D  C#CCY                 25     27
      * Transaction Type
     D  C#TRYP                28     29
      * Transaction Narrative
     D  C#NARR                30     59
      * Cheque Number
     D  C#CHQN                60     67  0
      * FT transaction reference
     D  C#PREF                68     82
      * DL/LE/GL/RE transaction reference
     D  C#TRN                 83     88
      * Movement amount
     D  C#AMT                 89     96P 0
      * Processing indicators Not blank = no update
      * ' ' = Update
      * Prono update indicator
     D  C#PRON                97     97
      * Olpos update indicator
     D  C#OLPS                98     98
      * Memos update indicator
     D  C#MEMS                99     99
      * Rsacmtpd write indicator
     D  C#RSAC               100    100
      * Module
     D  C#MOD                101    102
      * Olpos record number to update
      * '01' for FX
      * '02' for Interest movements
      * '03' for MM loans and deposits
     D  C#OLRC               103    104
      * FT Memos ledger balance override
      * 'Y' update ledger balance irrespective of
      * posting date
     D  C#FTOV               105    105
      *  Value date and posting date
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
      * Override posting date correction
      * for forward valued items
      * 'Y' prevents date being changed
     D  C#PSTO               112    112
      * Indicator to show if removal allowed Y, N or " "
     D  C#RPST               113    113
      * Removal set number
     D  C#RPNB               114    116  0
      * Removal type "C" = Credit entries
      * "D" = Debit entries
     D  C#RTYP               117    117
      * Booking branch
     D  C#BBRN               118    120
     D  C#ACO1               121    130  0
     D  C#ACOD               131    140  0
      * Other Transaction Reference                                                           CAP204
     D  C#OTR1               141    160                                                       CAP204
      *                                                                                       CAP205
      ** Movement type                                                                        CAP205
      *                                                                                       CAP205
     D  C#MTYP               161    161                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D  C#XRFI               162    164                                                       CLE134
     D  C#XRFN               165    174  0                                                    CLE134
                                                                                              CAP205
     D CPYR            DS
     D**  Data Structure for Compilation - Copyright Insertion
     D  ##CPY                  1     80
     D                                     DIM(1) CTDATA PERRCD(1)
      *
      ** Data structure for subroutine ZCBDYS
     D                 DS
     D  ZZDAT1                 1      8  0
     D  ZZYYA                  1      4  0
     D  ZZMMA                  5      6  0
     D  ZZDDA                  7      8  0
      *
     D                 DS
     D  ZZDAT2                 1      8  0
     D  ZZYYB                  1      4  0
     D  ZZMMB                  5      6  0
     D  ZZDDB                  7      8  0
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D** RECORD FORMATS FOR ACCESS TO BANK DETAILS
      ** Required variable declarations for ZSRSRC
     D@@RTN            S              1
     DZADATE           S              7
     DZDATE            S              6  0
     C/COPY ZSRSRC,ZDATE9Z2LE
     C/SPACE 5
      *****************************************************************
      * Process     :  MAINLINE                                       *
      * Function    :  Mainline processing                            *
      *                                                               *
      * Called by   :  None                                           *
      * Calls       :  SRINIT - Initial Processing - On First Call    *
      *                SRMAIN - Main Processing                       *
      *****************************************************************
      *
      **  Parameter list for current program invocation.
     C     *ENTRY        PLIST
     C                   PARM                    ##RTCD            7
     C                   PARM                    Z#BSTS
     C                   PARM                    Z#ASTS
     C                   PARM                    Z#WSTS
     C                   PARM                    Z#XSTS
     C                   PARM                    Z#YSTS
     C                   PARM                    Z#ZSTS
     C/COPY WNCPYSRC,AOOUSWU0C1
      ** Call Access Program for Bank Details
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'MAIN'        @STK(Q)
      *
      *................................................................
      *
      **  Initial processing - Once Only
     C     ##INIT        IFEQ      *BLANK
     C                   EXSR      SRINIT
     C                   MOVE      'Y'           ##INIT            1
     C                   ENDIF
      *
      *  Main processing
     C                   EXSR      SRMAIN
      *
      *................................................................
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
      **  Terminate program
     C                   SETON                                        LR
     C                   RETURN
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRMAIN                                         *
      * Function    :  Main processing                                *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :                                                 *
      *****************************************************************
     C     SRMAIN        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRMAIN'      @STK(Q)
      *
      *................................................................
      *
      ** Clear down all shadow postings in store (within AOSPOSU0)
      *
     C                   EXSR      SRCLR
      *
     C                   MOVEL     Z#BSTS        #BRCID            1
     C                   MOVEL     Z#ASTS        #ARCID            1
      *
      ** Generate 'BEFORE STATUS' account movements
      ** (if not insertion, when #BRCID will be blank)
      *
     C     #BRCID        IFNE      *BLANK
      *
     C                   MOVEL     'YES'         ##REVI            3
      *
      ** Set up IRS deal data structure.
     C                   MOVEL     Z#BSTS        IRDEAL
     C                   MOVEL     'B'           ##BEAF            1
     C                   EXSR      SRIRSW
      *
     C                   END
      *
      ** Generate 'AFTER STATUS' account movements
      ** (if not deletion, when CHTP will be 'R')
      *
     C                   MOVEL     *BLANK        ##REVI
      *
      ** Set up IRS deal data structure.
     C                   MOVEL     Z#ASTS        IRDEAL
     C     CHTP          IFNE      'R'
     C                   MOVEL     'A'           ##BEAF
     C                   EXSR      SRIRSW
     C                   END
      *
      ** Update database with shadow postings in store (within AOSPOSU0)
      *
     C                   EXSR      SRUPD
      *
      *................................................................
      *
     C     EXMAIN        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRIRSW                                         *
      * Function    :  Interest Rate Swap Deal Processing             *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  AOSPOSU0 - On-line Positions Update            *
      *****************************************************************
     C     SRIRSW        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q                 5 0
     C                   MOVEL     'SRIRSW'      @STK(Q)
      *
      *................................................................
      *
      **  Initialize work fields
      *
     C                   Z-ADD     *ZERO         ##VDAT            5 0          * event val dte
     C                   MOVEL     *BLANK        ##CCY             3            * event currency
     C                   Z-ADD     *ZERO         ##AMT            15 0          * event amount
     C                   MOVEL     *BLANK        ##NARR           30            * narrative
      *
      **  Store pay and receive settlement methods, accounts & branches
      *
     C                   MOVEL     PSETM         ##PAYM                         * pay method
     C                   MOVEL     UPACC         ##PAYA                         * pay account
     C                   MOVEL     POBR          ##PAYB                         * pay branch
     C                   MOVEL     RSETM         ##RECM                         * rec method
     C                   MOVEL     URACC         ##RECA                         * rec account
     C                   MOVEL     ROBR          ##RECB                         * rec branch
      *
      **  Store basic deal details
      *
     C                   MOVEL     DTYP          ##TRYP            2            * deal type
     C                   MOVEL     DLNO          ##TRN             6            * transact no.
     C                   MOVEL     BRCA          ##BBRN            3            * booking branc
      *
      ** Generate Premium movement for Caps, Collars and Floors
      *
     C     DTYP          IFEQ      'RR'
     C     CIR006        ANDEQ     'N'
     C     DTYP          OREQ      'RP'
     C     CIR006        ANDEQ     'N'
     C     DTYP          OREQ      'RF'
     C     CIR006        ANDEQ     'N'
      *
     C     UPPR          IFNE      *BLANK
     C     UPFE          ANDNE     *ZERO
     C                   Z-ADD     UPVD          ##VDAT
     C                   Z-ADD     UPFE          ##AMT
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     UCUCY         ##CCY
     C                   MOVEL     ##PAYD        ##SETD
     C                   ELSE
     C                   MOVEL     TCUCY         ##CCY
     C                   MOVEL     ##RECD        ##SETD
     C                   END
     C                   Z-ADD     001           ##RPNB
     C                   MOVEL     ##NAR(7)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C                   EXSR      P01
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP            1                          CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
     C                   ENDIF
     C                   GOTO      EXIRSW
     C                   ENDIF
      *
      ** Generate up-front fee movement
      ** ==============================
      *
     C     UPPR          IFNE      *BLANK
     C     UPFE          ANDNE     *ZERO
     C                   Z-ADD     UPVD          ##VDAT
     C                   Z-ADD     UPFE          ##AMT
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     UPPR          IFEQ      'P'
     C                   MOVEL     UCUCY         ##CCY
     C                   MOVEL     ##PAYD        ##SETD                         * Pay details
     C                   ELSE
     C                   MOVEL     TCUCY         ##CCY
     C                   MOVEL     ##RECD        ##SETD                         * Rec details
     C                   END
     C                   Z-ADD     001           ##RPNB                         * 1=Up front fees
     C                   MOVEL     ##NAR(1)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C                   EXSR      P01
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
     C                   END
      *
      ** Generate buy-out movement
      ** =========================
      *
     C     BAPR          IFNE      *BLANK
     C     BOAM          ANDNE     *ZERO
     C                   Z-ADD     BOVD          ##VDAT
     C                   Z-ADD     BOAM          ##AMT
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     BAPR          IFEQ      'P'
     C                   MOVEL     UCUCY         ##CCY
     C                   MOVEL     ##PAYD        ##SETD                         * Pay details
     C                   ELSE
     C                   MOVEL     TCUCY         ##CCY
     C                   MOVEL     ##RECD        ##SETD                         * Rec details
     C                   END
     C                   Z-ADD     002           ##RPNB                         * 2=buy-out
     C                   MOVEL     ##NAR(2)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C                   EXSR      P01
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
     C                   END
      *
      ** Generate interest account movement
      ** ==================================
      *
      ** Read cashflow events
      *
     C                   Z-ADD     *ZERO         ##AMT
     C                   MOVEL     *BLANKS       UCHK
     C                   MOVEL     *BLANKS       TCHK
     C                   MOVEL     'Y'           UCHK1             1                        AR740564
     C                   MOVEL     'Y'           TCHK1             1                        AR740564
      *
     C     KDLOL         SETLL     DLOLCFD0
     C     KDLOL         READE     DLOLCFD0                               99
     C  N99              Z-ADD     CFPYDT        ##VDAT
     C  N99              MOVEL     CFCCY         ##CCY
     C  N99              MOVEL     CFOTIN        ##OTIN            1                       AR1089180
      *
      ** Do while not end of file
      *
     C     *IN99         DOWEQ     '0'
      *
      ** On change of date or currency
      *
     C     CFPYDT        IFNE      ##VDAT
     C     ##AMT         ANDNE     *ZERO
     C     CFCCY         ORNE      ##CCY
     C     ##AMT         ANDNE     *ZERO
     C/COPY WNCPYSRC,AOOUSWU0K2
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     ##OTIN        IFEQ      'U'                                                     AR1089180
     C     DTYP          ANDNE     'RF'                                                    AR1089180
     C     DTYP          ANDNE     'RP'                                                    AR1089180
     C     DTYP          ANDNE     'RR'                                                    AR1089180
     C     ##OTIN        OREQ      'T'                                                     AR1089180
     C     DTYP          ANDEQ     'RF'                                                    AR1089180
     C     ##OTIN        OREQ      'U'                                                     AR1089180
     C     DTYP          ANDEQ     'RP'                                                    AR1089180
     C     ##OTIN        OREQ      'U'                                                     AR1089180
     C     DTYP          ANDEQ     'RR'                                                    AR1089180
     C     UEINR         ANDGT     CLRAT                                                   AR1089180
     C     ##OTIN        OREQ      'T'                                                     AR1089180
     C     DTYP          ANDEQ     'RR'                                                    AR1089180
     C     TEINR         ANDLT     FLRAT                                                   AR1089180
      *                                                                                    AR1089180
     C     ##AMT         IFLT      *ZERO
     C                   MOVEL     ##PAYD        ##SETD                         * Pay details
     C                   Z-SUB     ##AMT         ##AMT
     C                   ELSE                                                              AR1089180
     C                   MOVEL     ##PAYD        ##SETD                                    AR1089180
     C                   MOVEL     'R'           ##PYRC                                    AR1089180
     C                   Z-ADD     ##AMT         ##AMT                                     AR1089180
     C                   ENDIF                                                             AR1089180
      *                                                                                    AR1089180
     C                   ELSE
     C                   MOVEL     ##RECD        ##SETD                         * Rec details
      *                                                                                    AR1089180
     C     ##AMT         IFLT      *ZERO                                                   AR1089180
     C                   Z-SUB     ##AMT         ##AMT                                     AR1089180
     C                   MOVEL     'P'           ##PYRC                                    AR1089180
     C                   ENDIF                                                             AR1089180
      *                                                                                    AR1089180
     C                   END
     C                   Z-ADD     003           ##RPNB            3 0          * 3=Interest
     C                   MOVEL     ##NAR(3)      ##NARR
     C/COPY WNCPYSRC,AOOUSWU0K1
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C                   EXSR      P01
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
     C                   Z-ADD     *ZERO         ##AMT
     C                   END
      *
      ** If unknown cashflow determine it
      *
     C     CFAMNT        IFEQ      *ZERO
     C                   EXSR      SRDETC
      *
     C     CFAMNT        IFEQ      *ZERO
      *
      ** If cash flow amounts = zero for both sides have been met,
      ** then no further cash payments can be inferred, else
      ** continue on until this condition is met or there are
      ** no more records to process.
      *
     C     TCHK          IFEQ      'Y'
     C     UCHK          ANDEQ     'Y'
     C/COPY WNCPYSRC,AOOUSWU0C5
     C                   EXCEPT
     C                   GOTO      EXIRSW
     C/COPY WNCPYSRC,AOOUSWU0C6
     C                   ELSE
     C     CFOTIN        IFEQ      'U'
     C                   MOVEL     'Y'           UCHK              1
     C                   ELSE
     C                   MOVEL     'Y'           TCHK              1
     C                   ENDIF
     C                   GOTO      NXTRCD
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   END
      *
      ** If interest is capitalised and paid on maturity, maintain
      **   total of interest paid/received until maturity.
      *
     C     CFINPM        IFEQ      'C'
     C     CFINPM        OREQ      'A'
     C     CIR006        ANDEQ     'Y'
      *
     C     CFPYDT        IFEQ      MDAT
      *
     C     CFOTIN        IFEQ      'U'
     C     UIPRD         ADD       CFAMNT        CFAMNT
     C                   ELSE
     C     TIPRD         ADD       CFAMNT        CFAMNT
     C                   END
      *
     C                   ELSE
      *
     C     CFOTIN        IFEQ      'U'
     C                   ADD       CFAMNT        UIPRD
     C                   ELSE
     C                   ADD       CFAMNT        TIPRD
     C                   END
      *
     C                   Z-ADD     0             CFAMNT
      *
     C                   END
      *
     C                   END
      *
      ** Calculate the tax payable and deduct this from the cash-flow
      **   amount.
      *
     C     CFOTIN        IFEQ      'U'
     C     TAXI          ANDEQ     'Y'
      *
     C     CFAMNT        MULT      BNHKTR        W#WK01           30 9
     C     W#WK01        DIV(H)    100           CFTAXA
     C     CFAMNT        SUB       CFTAXA        CFAMNT
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         CFTAXA
     C                   ENDIF
      *
      ** Update the cash-flow record with the amount calculated.
      *
     C                   UPDATE    DLOLCFD0
      *
     C     NXTRCD        TAG
      *
      ** If interest is capitalized into principal, then ignore
      *
     C     CFINPM        IFEQ      'K'
     C     CFINPM        OREQ      'I'
     C     CIR006        ANDEQ     'Y'
     C                   Z-ADD     *ZERO         CFAMNT
     C                   END
      *
      ** Sign cashflow
      *
     C     CFOTIN        IFEQ      'U'
     C     DTYP          ANDNE     'RF'                                                     AR812349
     C     DTYP          ANDNE     'RP'                                                     AR812349
     C     DTYP          ANDNE     'RR'                                                     AR812349
     C     CFOTIN        OREQ      'T'                                                      AR812349
     C     DTYP          ANDEQ     'RF'                                                     AR812349
     C     CFOTIN        OREQ      'U'                                                      AR812349
     C     DTYP          ANDEQ     'RP'                                                     AR812349
     C     CFOTIN        OREQ      'U'                                                      AR812349
     C     DTYP          ANDEQ     'RR'                                                     AR812349
     C     UEINR         ANDGT     CLRAT                                                    AR812349
     C     CFOTIN        OREQ      'T'                                                      AR812349
     C     DTYP          ANDEQ     'RR'                                                     AR812349
     C     TEINR         ANDLT     FLRAT                                                    AR812349
     C                   Z-SUB     CFAMNT        CFAMNT
     C                   END
      *
      ** Cashflow Payment Date, Currency & Amount
      *
     C                   Z-ADD     CFPYDT        ##VDAT
     C                   MOVEL     CFCCY         ##CCY
     C                   ADD       CFAMNT        ##AMT
     C                   MOVEL     CFOTIN        ##OTIN                                    AR1089180
     C/COPY WNCPYSRC,AOOUSWU0K3
      *
      ** Read cashflow events
      *
     C     KDLOL         READE     DLOLCFD0                               99
     C                   END
      *
      ** Final payment
      *
     C     ##AMT         IFNE      *ZERO
      *
      ** Pass movement to write program (with appropriate instructions)
      *
     C     ##OTIN        IFEQ      'U'                                                     AR1089180
     C     DTYP          ANDNE     'RF'                                                    AR1089180
     C     DTYP          ANDNE     'RP'                                                    AR1089180
     C     DTYP          ANDNE     'RR'                                                    AR1089180
     C     ##OTIN        OREQ      'T'                                                     AR1089180
     C     DTYP          ANDEQ     'RF'                                                    AR1089180
     C     ##OTIN        OREQ      'U'                                                     AR1089180
     C     DTYP          ANDEQ     'RP'                                                    AR1089180
     C     ##OTIN        OREQ      'U'                                                     AR1089180
     C     DTYP          ANDEQ     'RR'                                                    AR1089180
     C     UEINR         ANDGT     CLRAT                                                   AR1089180
     C     ##OTIN        OREQ      'T'                                                     AR1089180
     C     DTYP          ANDEQ     'RR'                                                    AR1089180
     C     TEINR         ANDLT     FLRAT                                                   AR1089180
      *                                                                                    AR1089180
     C     ##AMT         IFLT      *ZERO
     C                   MOVEL     ##PAYD        ##SETD                         * Pay details
     C                   Z-SUB     ##AMT         ##AMT
     C                   ELSE                                                              AR1089180
     C                   MOVEL     ##PAYD        ##SETD                                    AR1089180
     C                   MOVEL     'R'           ##PYRC                                    AR1089180
     C                   Z-ADD     ##AMT         ##AMT                                     AR1089180
     C                   ENDIF                                                             AR1089180
      *                                                                                    AR1089180
     C                   ELSE
     C                   MOVEL     ##RECD        ##SETD                         * Rec details
      *                                                                                    AR1089180
     C     ##AMT         IFLT      *ZERO                                                   AR1089180
     C                   Z-SUB     ##AMT         ##AMT                                     AR1089180
     C                   MOVEL     'P'           ##PYRC                                    AR1089180
     C                   ENDIF                                                             AR1089180
      *                                                                                    AR1089180
     C                   END
     C                   Z-ADD     003           ##RPNB            3 0          * 3=Interest
     C                   MOVEL     ##NAR(3)      ##NARR
     C/COPY WNCPYSRC,AOOUSWU0C9
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C                   EXSR      P01
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
     C                   END
      *
     C/COPY WNCPYSRC,AOOUSWU0C2
      *................................................................
      *
     C     EXIRSW        TAG
      *
      ** Generate principal exchange movement
      ** ====================================
      *
     C                   MOVE      'N'           WFLAG1            1
      *
      **  If CIR003 is On, set up values for on-line updates.
      *
     C     CIR003        IFEQ      'Y'
     C                   MOVE      'Y'           WFLAG1
      *
      ** Principal Exchange on Value Date, use receipt settlement for
      ** our side and pay settlement for their side.
      *
     C     VDEI          IFEQ      'Y'
     C                   MOVE      VDAT          ##VDAT
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#WSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#YSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      UPAMT         ##AMT
     C                   MOVE      UCUCY         ##CCY
     C                   MOVE      'R'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXRSTM        IFEQ      00
     C     RXRSTM        OREQ      01
     C     RXRSTM        OREQ      02
     C     RXRSTM        OREQ      03
     C     RXRSTM        OREQ      04
     C     RXRSTM        OREQ      05
     C     RXRSTM        OREQ      06
     C     RXRSTM        OREQ      07
     C     RXRSTM        OREQ      08
     C     RXRSTM        OREQ      09
     C     RXRSTM        OREQ      12
     C     RXRSTM        OREQ      14
     C                   MOVE      RXRSTM        ##SETM
     C                   ELSE
     C                   MOVE      RSTM          ##SETM
     C                   ENDIF
      *
     C     RXRONS        IFNE      *BLANKS
     C                   MOVE      RXRONS        ##SETA
     C                   ELSE
     C                   MOVE      RONS          ##SETA
     C                   ENDIF
      *
     C     RXROBR        IFNE      *BLANKS
     C                   MOVE      RXROBR        ##BRCA
     C                   ELSE
     C                   MOVE      ROBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(4)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'V'           WEVFLG            1
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   MOVE      TPAMT         ##AMT
     C                   MOVE      TCUCY         ##CCY
     C                   MOVE      'P'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXPSTM        IFEQ      00
     C     RXPSTM        OREQ      01
     C     RXPSTM        OREQ      02
     C     RXPSTM        OREQ      03
     C     RXPSTM        OREQ      04
     C     RXPSTM        OREQ      05
     C     RXPSTM        OREQ      06
     C     RXPSTM        OREQ      07
     C     RXPSTM        OREQ      08
     C     RXPSTM        OREQ      09
     C     RXPSTM        OREQ      12
     C     RXPSTM        OREQ      14
     C                   MOVE      RXPSTM        ##SETM
     C                   ELSE
     C                   MOVE      PSTM          ##SETM
     C                   ENDIF
      *
     C     RXPONS        IFNE      *BLANKS
     C                   MOVE      RXPONS        ##SETA
     C                   ELSE
     C                   MOVE      PONS          ##SETA
     C                   ENDIF
      *
     C     RXPOBR        IFNE      *BLANKS
     C                   MOVE      RXPOBR        ##BRCA
     C                   ELSE
     C                   MOVE      POBR          ##BRCA
     C                   ENDIF
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(4)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'V'           WEVFLG            1
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
      ** Principal Exchange on Maturity date, use pay settlement for
      ** our side and receipt settlement for their side.
      *
     C     MDEI          IFEQ      'Y'
      *
     C     CIR003        IFEQ      'Y'
     C     BOVD          ANDNE     *ZEROS
     C                   MOVE      BOVD          ##VDAT
     C                   ELSE
     C                   MOVE      MDAT          ##VDAT
     C                   ENDIF
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#XSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#ZSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      UPAMT         ##AMT
     C                   MOVE      UCUCY         ##CCY
     C                   MOVE      'P'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXPSTM        IFEQ      00
     C     RXPSTM        OREQ      01
     C     RXPSTM        OREQ      02
     C     RXPSTM        OREQ      03
     C     RXPSTM        OREQ      04
     C     RXPSTM        OREQ      05
     C     RXPSTM        OREQ      06
     C     RXPSTM        OREQ      07
     C     RXPSTM        OREQ      08
     C     RXPSTM        OREQ      09
     C     RXPSTM        OREQ      12
     C     RXPSTM        OREQ      14
     C                   MOVE      RXPSTM        ##SETM
     C                   ELSE
     C                   MOVE      PSTM          ##SETM
     C                   ENDIF
      *
     C     RXPONS        IFNE      *BLANKS
     C                   MOVE      RXPONS        ##SETA
     C                   ELSE
     C                   MOVE      PONS          ##SETA
     C                   ENDIF
      *
     C     RXPOBR        IFNE      *BLANKS
     C                   MOVE      RXPOBR        ##BRCA
     C                   ELSE
     C                   MOVE      POBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(4)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'M'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   MOVE      TPAMT         ##AMT
     C                   MOVE      TCUCY         ##CCY
     C                   MOVE      'R'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXRSTM        IFEQ      00
     C     RXRSTM        OREQ      01
     C     RXRSTM        OREQ      02
     C     RXRSTM        OREQ      03
     C     RXRSTM        OREQ      04
     C     RXRSTM        OREQ      05
     C     RXRSTM        OREQ      06
     C     RXRSTM        OREQ      07
     C     RXRSTM        OREQ      08
     C     RXRSTM        OREQ      09
     C     RXRSTM        OREQ      12
     C     RXRSTM        OREQ      14
     C                   MOVE      RXRSTM        ##SETM
     C                   ELSE
     C                   MOVE      RSTM          ##SETM
     C                   ENDIF
      *
     C     RXRONS        IFNE      *BLANKS
     C                   MOVE      RXRONS        ##SETA
     C                   ELSE
     C                   MOVE      RONS          ##SETA
     C                   ENDIF
      *
     C     RXROBR        IFNE      *BLANKS
     C                   MOVE      RXROBR        ##BRCA
     C                   ELSE
     C                   MOVE      ROBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(4)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'M'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
      ** Principal change on "our" side.
      *
     C     PDEI          IFEQ      'Y'
     C     UNPCD         ANDNE     *ZERO
      *
     C                   MOVE      DLNO          KDLNO
     C                   MOVE      'U'           KOTIN
     C                   Z-ADD     UPAMT         WUPAMT           15 0
                                                                                              240412
     C     ##BEAF        IFEQ      'B'                                                        240412
     C     KDLPC         SETLL     DLPCSCRX                                                   240412
     C                   ELSE                                                                 240412
     C     KDLPC         SETLL     DLPCSCL0
     C                   ENDIF                                                                240412
      *
     C     *IN99         DOUEQ     '1'
                                                                                              240412
     C     ##BEAF        IFEQ      'B'                                                        240412
     C     KDLPC         READE     DLPCSCRX                               99                  240412
     C                   ELSE                                                                 240412
     C     KDLPC         READE     DLPCSCL0                               99
     C                   ENDIF                                                                240412
      *
      ** Principal Increase behaves as though exchanging on Value Date
      ** i.e. receipt settlement for 'our' side and pay for 'their' side.
      *
     C     *IN99         IFEQ      '0'
     C     WUPAMT        ANDLT     PAMT
     C     PMTP          ANDNE     'Y'
     C     ##BEAF        ANDNE     'B'                                                        240412
                                                                                              240412
     C     *IN99         OREQ      '0'                                                        240412
     C     WUPAMT        ANDLT     PAMT                                                       240412
     C     DTPR          ANDNE     'Y'                                                        240412
     C     ##BEAF        ANDEQ     'B'                                                        240412
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#WSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#YSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      PRDT          ##VDAT
     C     PAMT          SUB       WUPAMT        ##AMT
     C                   MOVE      UCUCY         ##CCY
     C                   MOVE      'R'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXRSTM        IFEQ      00
     C     RXRSTM        OREQ      01
     C     RXRSTM        OREQ      02
     C     RXRSTM        OREQ      03
     C     RXRSTM        OREQ      04
     C     RXRSTM        OREQ      05
     C     RXRSTM        OREQ      06
     C     RXRSTM        OREQ      07
     C     RXRSTM        OREQ      08
     C     RXRSTM        OREQ      09
     C     RXRSTM        OREQ      12
     C     RXRSTM        OREQ      14
     C                   MOVE      RXRSTM        ##SETM
     C                   ELSE
     C                   MOVE      RSTM          ##SETM
     C                   ENDIF
      *
     C     RXRONS        IFNE      *BLANKS
     C                   MOVE      RXRONS        ##SETA
     C                   ELSE
     C                   MOVE      RONS          ##SETA
     C                   ENDIF
      *
     C     RXROBR        IFNE      *BLANKS
     C                   MOVE      RXROBR        ##BRCA
     C                   ELSE
     C                   MOVE      ROBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(5)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'V'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
     C     *IN99         IFEQ      '0'
     C     WUPAMT        ANDGT     PAMT
     C     PMTP          ANDNE     'Y'
     C     ##BEAF        ANDNE     'B'                                                        240412
                                                                                              240412
     C     *IN99         OREQ      '0'                                                        240412
     C     WUPAMT        ANDGT     PAMT                                                       240412
     C     DTPR          ANDNE     'Y'                                                        240412
     C     ##BEAF        ANDEQ     'B'                                                        240412
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#XSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#ZSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      PRDT          ##VDAT
     C     WUPAMT        SUB       PAMT          ##AMT
     C                   MOVE      UCUCY         ##CCY
     C                   MOVE      'P'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXPSTM        IFEQ      00
     C     RXPSTM        OREQ      01
     C     RXPSTM        OREQ      02
     C     RXPSTM        OREQ      03
     C     RXPSTM        OREQ      04
     C     RXPSTM        OREQ      05
     C     RXPSTM        OREQ      06
     C     RXPSTM        OREQ      07
     C     RXPSTM        OREQ      08
     C     RXPSTM        OREQ      09
     C     RXPSTM        OREQ      12
     C     RXPSTM        OREQ      14
     C                   MOVE      RXPSTM        ##SETM
     C                   ELSE
     C                   MOVE      PSTM          ##SETM
     C                   ENDIF
      *
     C     RXPONS        IFNE      *BLANKS
     C                   MOVE      RXPONS        ##SETA
     C                   ELSE
     C                   MOVE      PONS          ##SETA
     C                   ENDIF
      *
     C     RXPOBR        IFNE      *BLANKS
     C                   MOVE      RXPOBR        ##BRCA
     C                   ELSE
     C                   MOVE      POBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(6)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'M'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
      ** Use the new principal amount
      *
     C                   Z-ADD     PAMT          WUPAMT
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
      ** Principal change on "their" side.
      *
     C     PDEI          IFEQ      'Y'
     C     TNPCD         ANDNE     *ZERO
      *
     C                   MOVE      DLNO          KDLNO
     C                   MOVE      'T'           KOTIN
     C                   Z-ADD     TPAMT         WTPAMT           15 0
                                                                                              240412
     C     ##BEAF        IFEQ      'B'                                                        240412
     C     KDLPC         SETLL     DLPCSCRX                                                   240412
     C                   ELSE                                                                 240412
     C     KDLPC         SETLL     DLPCSCL0
     C                   ENDIF                                                                240412
      *
     C     *IN99         DOUEQ     '1'
                                                                                              240412
     C     ##BEAF        IFEQ      'B'                                                        240412
     C     KDLPC         READE     DLPCSCRX                               99                  240412
     C                   ELSE                                                                 240412
     C     KDLPC         READE     DLPCSCL0                               99
     C                   ENDIF                                                                240412
      *
      ** Principal Increase behaves as though exchanging on Value Date
      ** i.e. receipt settlement for 'our' side and pay for 'their' side.
      *
     C     *IN99         IFEQ      '0'
     C     WTPAMT        ANDLT     PAMT
     C     PMTP          ANDNE     'Y'
     C     ##BEAF        ANDNE     'B'                                                        240412
                                                                                              240412
     C     *IN99         OREQ      '0'                                                        240412
     C     WTPAMT        ANDLT     PAMT                                                       240412
     C     DTPR          ANDNE     'Y'                                                        240412
     C     ##BEAF        ANDEQ     'B'                                                        240412
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#WSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#YSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      PRDT          ##VDAT
     C     PAMT          SUB       WTPAMT        ##AMT
     C                   MOVE      TCUCY         ##CCY
     C                   MOVE      'P'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXPSTM        IFEQ      00
     C     RXPSTM        OREQ      01
     C     RXPSTM        OREQ      02
     C     RXPSTM        OREQ      03
     C     RXPSTM        OREQ      04
     C     RXPSTM        OREQ      05
     C     RXPSTM        OREQ      06
     C     RXPSTM        OREQ      07
     C     RXPSTM        OREQ      08
     C     RXPSTM        OREQ      09
     C     RXPSTM        OREQ      12
     C     RXPSTM        OREQ      14
     C                   MOVE      RXPSTM        ##SETM
     C                   ELSE
     C                   MOVE      PSTM          ##SETM
     C                   ENDIF
      *
     C     RXPONS        IFNE      *BLANKS
     C                   MOVE      RXPONS        ##SETA
     C                   ELSE
     C                   MOVE      PONS          ##SETA
     C                   ENDIF
      *
     C     RXPOBR        IFNE      *BLANKS
     C                   MOVE      RXPOBR        ##BRCA
     C                   ELSE
     C                   MOVE      POBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(5)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'V'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
      ** Principal Decrease behaves as though exchanging on Maturity Date
      ** i.e. pay settlement for 'our' side and receipt for 'their' side.
      *
     C     *IN99         IFEQ      '0'
     C     WTPAMT        ANDGT     PAMT
     C     PMTP          ANDNE     'Y'
     C     ##BEAF        ANDNE     'B'                                                        240412
                                                                                              240412
     C     *IN99         OREQ      '0'                                                        240412
     C     WTPAMT        ANDGT     PAMT                                                       240412
     C     DTPR          ANDNE     'Y'                                                        240412
     C     ##BEAF        ANDEQ     'B'                                                        240412
      *
     C     ##BEAF        IFEQ      'B'
     C                   MOVEL     Z#XSTS        SETIN
     C                   ELSE
     C                   MOVEL     Z#ZSTS        SETIN
     C                   ENDIF
      *
     C                   MOVE      PRDT          ##VDAT
     C     WTPAMT        SUB       PAMT          ##AMT
     C                   MOVE      TCUCY         ##CCY
     C                   MOVE      'R'           ##PYRC
      *
      ** Ensure that correct settlement details
      *
     C     RXRSTM        IFEQ      00
     C     RXRSTM        OREQ      01
     C     RXRSTM        OREQ      02
     C     RXRSTM        OREQ      03
     C     RXRSTM        OREQ      04
     C     RXRSTM        OREQ      05
     C     RXRSTM        OREQ      06
     C     RXRSTM        OREQ      07
     C     RXRSTM        OREQ      08
     C     RXRSTM        OREQ      09
     C     RXRSTM        OREQ      12
     C     RXRSTM        OREQ      14
     C                   MOVE      RXRSTM        ##SETM
     C                   ELSE
     C                   MOVE      RSTM          ##SETM
     C                   ENDIF
      *
     C     RXRONS        IFNE      *BLANKS
     C                   MOVE      RXRONS        ##SETA
     C                   ELSE
     C                   MOVE      RONS          ##SETA
     C                   ENDIF
      *
     C     RXROBR        IFNE      *BLANKS
     C                   MOVE      RXROBR        ##BRCA
     C                   ELSE
     C                   MOVE      ROBR          ##BRCA
     C                   ENDIF
      *
     C                   MOVE      '004'         ##RPNB
     C                   MOVE      ##NAR(6)      ##NARR
      *
      ** Replace currency and convert movement amount to settlement
      ** currency equivalent.
      *
     C     CEU003        IFEQ      'Y'
     C                   MOVE      'M'           WEVFLG
     C                   EXSR      SRCNVT
     C                   ENDIF
      *
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'S'           ##MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C                   EXSR      SRMOVE
      *
     C                   ENDIF
      *
      ** Use the new principal amount
      *
     C                   Z-ADD     PAMT          WTPAMT
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   MOVE      'N'           WFLAG1
     C                   ENDIF
      *
     C/COPY WNCPYSRC,AOOUSWU0C8
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C*****************************************************************
      /SPACE 5
     C/COPY WNCPYSRC,AOOUSWU0C7
      *****************************************************************
      * Subroutine  :  SRMOVE                                         *
      * Function    :  Pass Movement To Write Program                 *
      *                                                               *
      * Called by   :  Various                                        *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRMOVE        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRMOVE'      @STK(Q)
      *
      *................................................................
      *
      ** Bypass if no amount to post
      *
     C     ##AMT         CABEQ     *ZERO         EXMOVE
      *
      ** Determine account movement settlement details
      *
     C                   CLEAR                   C#DTA
      *
     C     ##SETM        IFEQ      '01'
     C     ##SETM        OREQ      '02'
     C     ##SETM        OREQ      '07'
     C     ##SETM        OREQ      '08'
     C     ##SETM        OREQ      '12'
     C                   MOVEL     'N'           C#ATYP
     C                   MOVEL     ##NOSN        C#NOSN
     C                   ELSE
     C     ##SETM        IFEQ      '14'
     C                   MOVEL     'R'           C#ATYP
     C                   MOVEL     ##ACNO        C#ACNO
     C                   ELSE
     C     ##SETM        IFEQ      '04'
     C     ##SETM        OREQ      '05'
     C                   MOVEL     'P'           C#ATYP
     C                   MOVEL     ##CNUM        C#CNUM
     C                   MOVEL     ##ACOD        C#ACOD
     C                   MOVEL     ##ACSQ        C#ACSQ
     C                   MOVEL     ##BRCA        C#BRCA
     C                   END
     C                   END
     C                   END
      *
      * OLPOS Incoming/Outgoing Indicator 'I' or 'O'
     C     ##PYRC        IFEQ      'P'
     C                   MOVEL     'O'           C#IO                           * outgoing
     C                   ELSE
     C                   MOVEL     'I'           C#IO                           * incoming
     C                   END
      *
      * Currency of transaction
     C                   MOVEL     ##CCY         C#CCY
      *
      * Transaction type
     C                   MOVEL     ##TRYP        C#TRYP
      * Transaction Narrative
     C                   MOVEL     ##NARR        C#NARR
     C     ##REVI        IFEQ      'YES'
     C                   MOVE      '*'           C#NARR
     C                   END
      *
      * DL/LE/GL/RE transaction reference
     C                   MOVEL     ##TRN         C#TRN
      *
      * Movement amount
     C     ##PYRC        IFEQ      'P'
     C     ##REVI        ANDNE     'YES'
     C     ##PYRC        OREQ      'R'
     C     ##REVI        ANDEQ     'YES'
     C                   Z-SUB     ##AMT         C#AMT                          * pay ie credit
     C                   ELSE
     C                   Z-ADD     ##AMT         C#AMT                          * rec ie debit
     C                   END
      *
      * Module
     C                   MOVEL     'DL'          C#MOD
      *
      * Olpos record number to update
      * '01' for FX
      * '02' for Interest movements
      * '03' for MM loans and deposits
     C     CIR003        IFEQ      'Y'
     C     WFLAG1        ANDEQ     'Y'
     C                   MOVE      '01'          C#OLRC
     C                   ELSE
     C                   MOVE      '02'          C#OLRC
     C                   ENDIF
      *
      * Value date and posting date
     C                   Z-ADD     ##VDAT        C#VDAT
     C                   Z-ADD     ##VDAT        C#PSTD
      *
      * Indicator to show if removal allowed Y, N or " "
     C                   MOVEL     'Y'           C#RPST
      *
      * Removal set number
     C                   Z-ADD     ##RPNB        C#RPNB
      *
      * Removal type "C" = Credit entries
      *              "D" = Debit entries
     C                   MOVEL     'C'           C#RTYP
      *
      * Booking branch
     C                   MOVEL     ##BBRN        C#BBRN
      *
      *  If settlement details are present
      *  AOSPOSU0 will be called to update PRONO, MEMOS, RSACMTPD, OLPOS
      *
      *  OTHERWISE
      *
      *  If no settlement details are present
      *  AOSPOSU0 will be called to only update OLPOS
      *
     C     C#ATYP        IFEQ      *BLANK
      *
      * Set account type indicator to signify no settlement
     C                   MOVEL     'X'           C#ATYP
      *
      * Set update indicators for no update
     C                   MOVE      'N'           C#PRON
     C                   MOVE      'N'           C#MEMS
     C                   MOVE      'N'           C#RSAC
     C                   END
      *                                                                                       CAP205
      ** Set C#MTYP to ##MTYP                                                                 CAP205
      *                                                                                       CAP205
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     ##MTYP        C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *
      *  Call AOSPOSU0
      *
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'AOSPOSU0'    W0KEY            29
     C                   Z-ADD     902           W0ERNB            3 0
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
     C     EXMOVE        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRDETC                                         *
      * Function    :  Determine Cashflow amount                      *
      *                                                               *
      * Called by   :  Various                                        *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRDETC        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRDETC'      @STK(Q)
      *
      *................................................................
      *
      **  If the interest accrual control date is after the cash-flow
      **    start date, calulate the interest to the control date. Then
      **    use the rest of this routine to calculate the interest
      **    from there to the end date.
      *
     C     CFOTIN        IFEQ      'U'
      *
     C     UIACD         IFGT      CFSLIP
     C                   Z-ADD     UIACD         ##IACD            5 0
     C     UAITC         SUB       UIPRD         ##TOTI           15 0
     C                   ELSE
     C                   Z-ADD     CFSLIP        ##IACD
     C                   Z-ADD     *ZERO         ##TOTI
     C                   ENDIF
      *
     C                   ELSE
      *
     C     TIACD         IFGT      CFSLIP
     C                   Z-ADD     TIACD         ##IACD
     C     TAITC         SUB       TIPRD         ##TOTI
     C                   ELSE
     C                   Z-ADD     CFSLIP        ##IACD
     C                   Z-ADD     *ZERO         ##TOTI
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** DETERMINE PRINCIPAL & RATE AS AT LAST INTEREST PAYMENT DATE
      *
     C                   MOVEL     CFBEAF        ACBEAF
     C                   Z-ADD     CFDLNO        ACDLNO
     C                   MOVE      CFOTIN        ACOTIN
     C                   Z-ADD     CFSLIP        ACPRDT
     C     DLOLAK        SETGT     DLOLACD0
     C     DLOLAP        READPE    DLOLACD0                               99    *
      *
     C     *IN99         IFEQ      '1'
     C     DLOLAK        SETLL     DLOLACD0
     C     DLOLAP        READE     DLOLACD0                               99    *
     C                   END
      *
      ** SET PRINCIPAL & RATE AS AT LAST INTEREST PAYMENT DATE
      ** AND DATE INTEREST CALCULATED TO
      *
     C                   Z-ADD     ACPCPL        ##PCPL           15 0
     C                   Z-ADD     ACEINR        ##EINR           11 7
     C                   MOVEL     ACRTTP        ##RTTP            1
      *
      ** REPOSITION POINTER TO AFTER RECORD JUST READ
      *
     C     DLOLAK        SETGT     DLOLACD0
      *
      ** READ FROM THE DEAL ACTIVITY FILE
      *
     C     DLOLAP        READE     DLOLACD0                               99    *
      *
      ** READ UP TO CASHFLOW NEXT INTEREST PAYMENT DATE
      *
     C     *IN99         DOWEQ     '0'
     C     ACPRDT        ANDLT     CFNIPD
      *
      ** CALCULATE INTEREST FROM LAST DATE TO DEAL ACTIVITY DATE.
      ** RATE USED IS EFFECTIVE INTEREST RATE OFF DEAL ACTIVITY
      *
     C                   Z-ADD     ##PCPL        ZDLAMT
      *
      ** If CIR002 is switched on, add unsettled interest to principal.
      *
     C     CIR002        IFEQ      'Y'
      *
      ** If CIR006 is On, consider only int. proc. methods A,I & L.
      *
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'L'
      *
     C/COPY WNCPYSRC,AOOUSWU0K5
      *
     C     ACOTIN        IFEQ      'U'
     C                   ADD       OUSI          ZDLAMT
     C                   ADD       OUSA          ZDLAMT
     C                   ELSE
     C                   ADD       TUSI          ZDLAMT
     C                   ADD       TUSA          ZDLAMT
     C                   END
      *
     C                   END
      *
     C                   Z-ADD     ##EINR        ZDLRAT
     C                   Z-ADD     ##IACD        ZCBSDT
     C                   Z-ADD     ACPRDT        ZCBEDT
     C                   MOVEL     CFINCL        ZCBCBS
     C     CFINPM        IFNE      'Y'
     C                   EXSR      ZDLINT                                       * DISC./INT.
     C                   ELSE
     C                   EXSR      SRCIYD                                       * YIELD
     C                   END
      *
     C                   ADD       ZDLOUT        ##TOTI
      *
      ** SET PRINCIPAL & RATE
      ** AND DATE INTEREST CALCULATED TO
      *
     C                   Z-ADD     ACPCPL        ##PCPL
     C                   Z-ADD     ACEINR        ##EINR
     C                   MOVEL     ACRTTP        ##RTTP
     C                   Z-ADD     ACPRDT        ##IACD
      *
      ** READ FROM THE DEAL ACTIVITY FILE
      *
     C     DLOLAP        READE     DLOLACD0                               99    *
     C                   END
      *
      ** CALCULATE INTEREST FROM LAST DATE TO NEXT INTEREST PAYMENT DATE
      ** RATE USED IS EFFECTIVE INTEREST RATE OFF DEAL ACTIVITY FILE.
      *
     C     ##IACD        IFLT      CFNIPD
     C                   Z-ADD     ##PCPL        ZDLAMT
      *
      ** If CIR002 is switched on, add unsettled interest to principal.
      *
     C     CIR002        IFEQ      'Y'
      *
      ** If CIR006 is On, consider only int. proc. methods A,I & L.
      *
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'A'
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'I'
     C     CIR006        OREQ      'Y'
     C     CFINPM        ANDEQ     'L'
      *
     C/COPY WNCPYSRC,AOOUSWU0K6
      *
     C     CFOTIN        IFEQ      'U'
     C                   ADD       OUSI          ZDLAMT
     C                   ADD       OUSA          ZDLAMT
     C                   ELSE
     C                   ADD       TUSI          ZDLAMT
     C                   ADD       TUSA          ZDLAMT
     C                   END
      *
     C                   END
      *
     C                   Z-ADD     ##EINR        ZDLRAT
     C                   Z-ADD     ##IACD        ZCBSDT
     C                   Z-ADD     CFNIPD        ZCBEDT
     C                   MOVEL     CFINCL        ZCBCBS
     C     CFINPM        IFNE      'Y'
     C                   EXSR      ZDLINT                                       * DISC./INT.
     C                   ELSE
     C                   EXSR      SRCIYD                                       * YIELD
     C                   END
     C                   ADD       ZDLOUT        ##TOTI
     C                   END
      *
      ** SET CASHFLOW AMOUNT
      *
      ** Make sure that only the first transaction in events file                           AR740564
      ** will be processed.                                                                 AR740564
      *                                                                                     AR740564
     C     CFOTIN        IFEQ      'U'                                                      AR740564
     C     UCHK1         ANDEQ     'Y'                                                      AR740564
     C                   ADD       UAIAP         ##TOTI                                     AR740564
     C                   ADD       UAIAN         ##TOTI                                     AR740564
     C                   MOVEL     'N'           UCHK1                                      AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C     CFOTIN        IFEQ      'T'                                                      AR740564
     C     TCHK1         ANDEQ     'Y'                                                      AR740564
     C                   ADD       TAIAP         ##TOTI                                     AR740564
     C                   ADD       TAIAN         ##TOTI                                     AR740564
     C                   MOVEL     'N'           TCHK1                                      AR740564
     C                   ENDIF                                                              AR740564
      *                                                                                     AR740564
     C                   Z-ADD     ##TOTI        CFAMNT
      *
      ** If CIR002 is switched on, zeroise the unsettled interest
      **   once it has been used.
      *
     C     CIR002        IFEQ      'Y'
     C     CIR006        OREQ      'Y'
     C/COPY WNCPYSRC,AOOUSWU0K7
      *
     C     CFOTIN        IFEQ      'U'
     C                   Z-ADD     0             OUSI
     C                   Z-ADD     0             OUSA
     C                   ELSE
     C                   Z-ADD     0             TUSI
     C                   Z-ADD     0             TUSA
     C                   END
      *
     C                   END
      *
      *
      *................................................................
      *
     C     EXDETC        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRCIYD                                         *
      * Function    :  Calculate Interest on a Yield Basis            *
      *                                                               *
      * Called by   :  Various                                        *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRCIYD        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRCIYD'      @STK(Q)
      *
      *................................................................
      *
      * INITIALIZE FIELDS
      *
     C                   Z-ADD     ZDLAMT        ZDLAMT
     C                   Z-ADD     ZDLRAT        ZDLRAT
     C                   Z-ADD     *ZERO         ZDLOUT
      *
      * FIND NO. OF DAYS IN PERIOD AND YEAR
      *
     C                   EXSR      ZCBDYS
      *
      ** INTEREST = PRINCIPAL ( 1 - 1 / ( 1 + RATE X NUMBER OF DAYS/360))
      **       I.E. PRINCIPAL ( 1 - 360 / ( 360 + RATE X NUMBER OF DAYS))
      *
     C     ZCBDIV        MULT      100           ZIWRK3            5 0
      *
     C     ZCBDAY        MULT      ZDLRAT        ZIWRK4           15 7
     C                   ADD       ZIWRK3        ZIWRK4
      *
     C     ZIWRK4        IFNE      *ZERO
     C     ZIWRK3        DIV(H)    ZIWRK4        ZIWRK5           15 9
     C     1             SUB       ZIWRK5        ZIWRK5
     C     ZDLAMT        MULT(H)   ZIWRK5        ZDLOUT
     C                   END
      *
      *................................................................
      *
     C     EXCIYD        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  SRCNVT                                         *
      * Function    :  Determine settlement currency and convert      *
      *                amount.                                        *
      *                                                               *
      * Called by   :  SR/SRIRSW                                      *
      * Calls       :  PGM/EU0200                                     *
      *****************************************************************
     C     SRCNVT        BEGSR
      ** Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRCNVT'      @STK(Q)
      ** If Event is Value Date/Principal Increase, check if settlement
      ** currency is entered, call PGM/EU0200.
     C     WEVFLG        IFEQ      'V'
     C     RSCY          IFNE      UCUCY
     C     RSCY          ANDNE     *BLANKS
     C     ##PYRC        ANDEQ     'R'
     C                   MOVE      UCUCY         ##CCY
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD
     C                   PARM      ##AMT         P#FRAM
     C                   PARM      ##CCY         P#FRCY
     C                   PARM      RSCY          P#TOCY
     C                   PARM      *ZEROS        P#OUTA
     C                   PARM      *ZEROS        P#INTA
     C                   PARM      *ZEROS        P#EXRT
     C                   PARM      *BLANKS       P#MDIN
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     911           W0ERNB
     C                   EXSR      SRERR
     C                   ELSE
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      RSCY          ##CCY
     C                   ENDIF
     C                   ENDIF
     C     PSCY          IFNE      TCUCY
     C     PSCY          ANDNE     *BLANKS
     C     ##PYRC        ANDEQ     'P'
     C                   MOVE      TCUCY         ##CCY
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD
     C                   PARM      ##AMT         P#FRAM
     C                   PARM      ##CCY         P#FRCY
     C                   PARM      PSCY          P#TOCY
     C                   PARM      *ZEROS        P#OUTA
     C                   PARM      *ZEROS        P#INTA
     C                   PARM      *ZEROS        P#EXRT
     C                   PARM      *BLANKS       P#MDIN
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     912           W0ERNB
     C                   EXSR      SRERR
     C                   ELSE
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      PSCY          ##CCY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      ** If Event is Maturity Date/Principal Decrease, check if settle-
      ** ment currency is entered, call PGM/EU0200.
      *
     C     WEVFLG        IFEQ      'M'
     C     RSCY          IFNE      TCUCY
     C     RSCY          ANDNE     *BLANKS
     C     ##PYRC        ANDEQ     'R'
     C                   MOVE      TCUCY         ##CCY
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD
     C                   PARM      ##AMT         P#FRAM
     C                   PARM      ##CCY         P#FRCY
     C                   PARM      RSCY          P#TOCY
     C                   PARM      *ZEROS        P#OUTA
     C                   PARM      *ZEROS        P#INTA
     C                   PARM      *ZEROS        P#EXRT
     C                   PARM      *BLANKS       P#MDIN
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     913           W0ERNB
     C                   EXSR      SRERR
     C                   ELSE
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      RSCY          ##CCY
     C                   ENDIF
     C                   ENDIF
     C     PSCY          IFNE      UCUCY
     C     PSCY          ANDNE     *BLANKS
     C     ##PYRC        ANDEQ     'P'
     C                   MOVE      UCUCY         ##CCY
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD
     C                   PARM      ##AMT         P#FRAM
     C                   PARM      ##CCY         P#FRCY
     C                   PARM      PSCY          P#TOCY
     C                   PARM      *ZEROS        P#OUTA
     C                   PARM      *ZEROS        P#INTA
     C                   PARM      *ZEROS        P#EXRT
     C                   PARM      *BLANKS       P#MDIN
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     914           W0ERNB
     C                   EXSR      SRERR
     C                   ELSE
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      PSCY          ##CCY
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *................................................................
     C     EXCNVT        TAG
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
     C                   ENDSR
     C********************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  SRUPD    : Update database with shadow postings in store     *
      *                                                               *
      *  CALLED BY: Various                                           *
      *                                                               *
      *  CALLS    : SRERR - Report errors                             *
      *                                                               *
      *****************************************************************
     C     SRUPD         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRUPD'       @STK(Q)
      *
      *................................................................
      *
      *  Call AOSPOSU0 to update database
      *
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*UPDATE '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     903           W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
      *  Unwind subroutine stack name
      *
     C     EXUPD         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  SRCLR    : Clear all postings in store                       *
      *                                                               *
      *  CALLED BY: UPDATE - Update database                          *
      *                                                               *
      *  CALLS    : SRERR - Report errors                             *
      *                                                               *
      *****************************************************************
     C     SRCLR         BEGSR
      *
      *  Set up subroutine stack name
      *
     C                   ADD       1             Q
     C                   MOVEL     'SRCLR'       @STK(Q)
      *
      *................................................................
      *
      *  Clear arrays in AOSPOSU0
      *
     C                   CLEAR                   C#DTA
     C                   CALL      'AOSPOSU0'                           9090
     C     R#RTN         PARM      *BLANKS       O#RTN             7
     C                   PARM      '*CLEAR  '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     R#RTN         ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE
     C                   MOVEL     'AOSPOSU0'    W0KEY
     C                   Z-ADD     901           W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      *................................................................
      *
      *  Unwind subroutine stack name
      *
     C     EXCLR         TAG
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * Subroutine  :  P01                                            *
      * Function    :  Determine settlement currency and convert      *
      *                amount.                                        *
      *                                                               *
      * Called by   :  SRIRSW                                         *
      * Calls       :  PGM/EU0200                                     *
      *****************************************************************
     C     P01           BEGSR
      *
      ** Check if CEU003 is ON.
      *
     C     CEU003        IFEQ      'Y'
      *
      ** Single currency swaps
      *
     C     DTYP          IFEQ      'RS'
     C     PSCY          ANDNE     *BLANKS
     C     PSCY          ANDNE     UCUCY
     C                   MOVE      UCUCY         ##CCY
     C                   ENDIF
      *
     C     DTYP          IFEQ      'RR'
     C     DTYP          OREQ      'RF'
     C     DTYP          OREQ      'RP'
     C     PSCY          IFNE      *BLANKS
     C     PSCY          ANDNE     UCUCY
     C                   MOVE      UCUCY         ##CCY
     C                   ENDIF
     C                   ENDIF
      *
     C     DTYP          IFEQ      'RS'
     C     DTYP          OREQ      'RR'
     C     DTYP          OREQ      'RF'
     C     DTYP          OREQ      'RP'
     C     PSCY          IFNE      ##CCY
     C     PSCY          ANDNE     *BLANKS
      *
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD            7
     C                   PARM      ##AMT         P#FRAM           18 3
     C                   PARM      ##CCY         P#FRCY            3
     C                   PARM      PSCY          P#TOCY            3
     C                   PARM      *ZEROS        P#OUTA           15 0
     C                   PARM      *ZEROS        P#INTA           18 3
     C                   PARM      *ZEROS        P#EXRT           15 9
     C                   PARM      *BLANKS       P#MDIN            1
      *
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     906           W0ERNB            3 0
     C                   EXSR      SRERR
      *
     C                   ELSE
      *
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      PSCY          ##CCY
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
      ** Cross currency swaps
      *
     C     DTYP          IFEQ      'RX'
      *
      ** Event currency is equal to 'Our Currency'
      *
     C     UCUCY         IFEQ      ##CCY
      *
     C     DTYP          IFEQ      'RX'
     C     PSCY          ANDNE     *BLANKS
     C     PSCY          ANDNE     UCUCY
     C                   MOVE      UCUCY         ##CCY
     C                   ENDIF
      *
     C     PSCY          IFNE      ##CCY
     C     PSCY          ANDNE     *BLANKS
      *
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD            7
     C                   PARM      ##AMT         P#FRAM           18 3
     C                   PARM      ##CCY         P#FRCY            3
     C                   PARM      PSCY          P#TOCY            3
     C                   PARM      *ZEROS        P#OUTA           15 0
     C                   PARM      *ZEROS        P#INTA           18 3
     C                   PARM      *ZEROS        P#EXRT           15 9
     C                   PARM      *BLANKS       P#MDIN            1
      *
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     907           W0ERNB            3 0
     C                   EXSR      SRERR
      *
     C                   ELSE
      *
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      PSCY          ##CCY
     C                   ENDIF
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Event currency is equal to 'Their Currency'
      *
     C     DTYP          IFEQ      'RX'
     C     RSCY          ANDNE     *BLANKS
     C     RSCY          ANDNE     TCUCY
     C                   MOVE      TCUCY         ##CCY
     C                   ENDIF
      *
     C     RSCY          IFNE      ##CCY
     C     RSCY          ANDNE     *BLANKS
      *
     C                   CALL      'EU0200'                             90
     C                   PARM      *BLANKS       P#RTCD            7
     C                   PARM      ##AMT         P#FRAM           18 3
     C                   PARM      ##CCY         P#FRCY            3
     C                   PARM      RSCY          P#TOCY            3
     C                   PARM      *ZEROS        P#OUTA           15 0
     C                   PARM      *ZEROS        P#INTA           18 3
     C                   PARM      *ZEROS        P#EXRT           15 9
     C                   PARM      *BLANKS       P#MDIN            1
      *
     C     *IN90         IFEQ      '1'
     C     P#RTCD        ORNE      *BLANKS
     C                   MOVEL     '*CALL   '    W0FILE            8
     C                   MOVEL     'EU0200  '    W0KEY            29
     C                   Z-ADD     908           W0ERNB            3 0
     C                   EXSR      SRERR
      *
     C                   ELSE
      *
     C                   Z-ADD     P#OUTA        ##AMT
     C                   MOVE      RSCY          ##CCY
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      *                                                               *
      *  SRERR    : Report error and close down program               *
      *                                                               *
      *  CALLED BY: Various                                           *
      *  CALLS    : *NONE                                             *
      *                                                               *
      *****************************************************************
     C     SRERR         BEGSR
      *
      *  Dump program
      *
     C                   DUMP
      *
      *  Close down program
      *
     C                   SETON                                        LR
     C                   MOVEL     '*ERROR*'     ##RTCD
     C                   RETURN
      *
     C     EXERR         ENDSR
      *****************************************************************
      /SPACE 5
      *****************************************************************
      * Subroutine  :  SRINIT                                         *
      * Function    :  Initial processing - First Call Only           *
      *                                                               *
      * Called by   :  Mainline                                       *
      * Calls       :  None                                           *
      *****************************************************************
     C     SRINIT        BEGSR
      *
      **  Set up subroutine stack name
     C                   ADD       1             Q
     C                   MOVEL     'SRINIT'      @STK(Q)
      *
      *................................................................
      *
      **  Initialise work fields
     C                   MOVEL     'P'           ##PAY
     C                   MOVEL     'R'           ##REC
     C                   MOVEL     *BLANKS       R#RTN             7
      *
      ** Key lists
      *
     C     DLOLAK        KLIST
     C                   KFLD                    ACBEAF
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C                   KFLD                    ACPRDT
     C*
     C     DLOLAP        KLIST
     C                   KFLD                    ACBEAF
     C                   KFLD                    ACDLNO
     C                   KFLD                    ACOTIN
     C*
     C     KDLOL         KLIST
     C                   KFLD                    ##BEAF
     C                   KFLD                    DLNO
      *
     C     KDLPC         KLIST
     C                   KFLD                    KDLNO             6 0
     C                   KFLD                    KOTIN             1
      *
      **  Set Date Format Indicator
      *
     C                   MOVE      '0'           *IN98
      *
      ** Access AO/AOSARDR0 to determine if Compounding of Interest
      **   required.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR002'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CIR002'      W0KEY
     C                   Z-ADD     904           W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR002            1
     C                   ELSE
     C                   MOVEL     'N'           CIR002
     C                   END
     C/COPY WNCPYSRC,AOOUSWU0K8
      *
      * Call Access prog. for Tax rate.
      *
     C                   CALL      'AODEALR1'
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDDEAL        PARM      SDDEAL        DSSDY
      *
      * Handle database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    W0FILE
     C                   MOVEL     '*FIRST'      W0KEY
     C                   Z-ADD     905           W0ERNB
     C                   EXSR      SRERR
     C                   END
      *
      ** Check if CEU003 is switched *ON.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CEU003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVE      'Y'           CEU003            1
     C                   ELSE
     C                   MOVE      'N'           CEU003
     C                   END
      *
      **  Determine if CIR003 is Installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR003'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CIR003'      W0KEY
     C                   Z-ADD     909           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR003            1
     C                   ELSE
     C                   MOVEL     'N'           CIR003
     C                   ENDIF
      *
      **  Determine if CIR006 is Installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*VERIFY'     @OPTN             7
     C                   PARM      'CIR006'      @SARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    W0FILE
     C                   MOVEL     'CIR006'      W0KEY
     C                   Z-ADD     910           W0ERNB
     C                   EXSR      SRERR
     C                   ENDIF
      *                                                                   CIR006
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           CIR006            1
     C                   ELSE
     C                   MOVEL     'N'           CIR006
     C                   ENDIF
      *                                                                                       CAP205
      **  Determine if CAP205 is Installed.                                                   CAP205
      *                                                                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       @RTCD                                        CAP205
     C                   PARM      '*VERIFY'     @OPTN                                        CAP205
     C                   PARM      'CAP205'      @SARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
      *                                                                                       CAP205
     C     @RTCD         IFNE      *BLANKS                                                    CAP205
     C     @RTCD         ANDNE     '*NRF   '                                                  CAP205
     C                   MOVEL     'SCSARDPD'    W0FILE                                       CAP205
     C                   MOVEL     'CAP205'      W0KEY                                        CAP205
     C                   Z-ADD     915           W0ERNB                                       CAP205
     C                   EXSR      SRERR                                                      CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       CAP205
     C     @RTCD         IFEQ      *BLANKS                                                    CAP205
     C                   MOVEL     'Y'           CAP205            1                          CAP205
     C                   ELSE                                                                 CAP205
     C                   MOVEL     'N'           CAP205                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                   CEU003
     C/COPY WNCPYSRC,AOOUSWU0C3
      *
      **  Copyright
     C                   MOVEA     ##CPY         ##BIS            80
      *
      *................................................................
      *
     C     EXINIT        TAG
      *
      **  Unwind subroutine stack name
     C                   MOVEA     *BLANKS       @STK(Q)
     C                   SUB       1             Q
      *
     C                   ENDSR
      *****************************************************************
      /SPACE 5
     C/COPY WNCPYSRC,AOOUSWU0K4
      /SPACE 5
     C/COPY ZSRSRC,ZDLINTZ1LE
      /SPACE 5
     C/COPY ZSRSRC,ZCBDYSZ1LE
     C/SPACE 5
     C/COPY WNCPYSRC,AOOUSWU0C4
      * Release DLOLCFPD record
     ODLOLCFD0  E
**   ZF29 DAY NOS OF FEB 29 TO 2096 (INCLUDING 2000)
0006001521029820444305904073650882610287117481320914670161311759219053
2051421975234362489726358278192928030741322023366335124365853804639507
40968424294389045351
** ##NAR  **      NARRATIVES
UP FRONT FEE
BUY OUT
INTEREST
PRINCIPAL
PRINCIPAL INCREASE
PRINCIPAL DECREASE
PREMIUM
** ##CPY  **      OBJECT COPYRIGHT
(c) Misys International Banking Systems Ltd. 2001
     X/COPY WNCPYSRC,AOOUSWU0X1
