     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas RE Zero Balancing')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Retail Module                                        *
      *                                                               *
      *  RE100612 - Zero-Balancing                                    *
      *                                                               *
      *  Function:  This program performs zero-balancing for a given  *
      *             child account.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. AR968075           Date 04Jun12               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CER059             Date 19Jul10               *
      *                 CER043             Date 08Oct07               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP204             Date 03Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      *                 212904             Date 20May03               *
      *                 217028             Date 24Apr03               *
      *                 216421             Date 06Apr03               *
      *                 213569             Date 10Feb03               *
      *                 214360             Date 03Feb03               *
      *                 213196             Date 21Jan03               *
      *                 212899             Date 13Jan03               *
      *                 CRE008  *CREATE    Date 19Feb02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR968075 - Top sweep for UPM INTGBP not happenning in CoB    *
      *             CAP204 changed PGM to stop using Lf/ACPO1         *
      *             Need to use ACPO1 as Sweep process looking at     *
      *             GE-CX entries added to Pf/GECXPD as part of       *
      *             REC100816 PGMs. (Child: AR968077)                 *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CAP204 - Retail Account Transfer                             *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  212904 - Balance Purging - Balances purged on Top            *
      *           accounts should not be zero-balanced                *
      *  217028 - Error with sweeping gross                           *
      *  216421 - External tops are back-valued                       *
      *  213569 - Charges errors                                      *
      *           Generate charges for external tops/sweeps           *
      *  214360 - Cash Management Deferred Posting                    *
      *  213196 - Holidays are not checked for top/sweeps             *
      *  212899 - Zero balancing gross should ignore previous days    *
      *  CRE008 - Cash Management                                     *
      *                                                               *
      *****************************************************************
 
     FGLACBTL0  IF   E           K DISK    INFSR(*PSSR)
     FRECMLCL3  IF   E           K DISK    INFSR(*PSSR)
     F***ACPO1**   IF   F  400    18AIDISK    KEYLOC(2) USROPN                                CGL029
     F***ACPO1     IF   F  400    24AIDISK    KEYLOC(2) USROPN                         CGL029 CAP204
     F***GLACPML0  IF   F  400    24AIDISK    KEYLOC(2) USROPN                       CAP204 AR968075
     FACPO1     IF   F  620    24AIDISK    KEYLOC(2) USROPN                                 AR968075
     FRSACMTL6  IF   E           K DISK    USROPN
     F                                     PREFIX(E_)
     FREICSDL6  IF   E           K DISK    INFSR(*PSSR)                         216421
     F                                     PREFIX(D_)                           216421
     FREICSIL0  IF   E           K DISK    INFSR(*PSSR)                         216421
     F                                     PREFIX(I_)                           216421
     FGLPSTTL0  IF   E           K DISK    INFSR(*PSSR)                         216421
     F                                     RENAME(APOSTPDF:GLPSTTD0)            216421
     F                                     PREFIX(U_)                           216421
     FRE100612P1O    E             PRINTER INFSR(*PSSR) USROPN
     F                                     INFDS(SPOOL1)
 
      *****************************************************************
      * Standard D Specifications
     D/COPY ZACPYSRC,RECMSTDD
      * Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
      *****************************************************************
 
     D I_CACD          S             10  0                                                    CGL029
     D I_PACD          S             10  0                                                    CGL029
 
      * Key to A/c postings file
     D                 DS
     D***ACPOK**                 1     18                                                     CGL029
     D ACPOK                   1     24                                                       CGL029
     D**CUS*****               1      6  0                                                    CSD027
     D  CUS                    1      6A                                                      CSD027
     D  CCY                    7      9
     D***ACD****               10     13  0                                                   CGL029
     D***ASN****               14     15  0                                                   CGL029
     D***BRC****               16     18                                                      CGL029
     D  ACD                   10     19  0                                                    CGL029
     D  ASN                   20     21  0                                                    CGL029
     D  BRC                   22     24                                                       CGL029
 
 
      * Input Entry
     D I_ENTRY       E DS                  EXTNAME(APOSTPD)
     D                                     PREFIX(E_)
 
 
     D #_INF           S             70    DIM(6)  CTDATA PERRCD(1)
 
 
     D                 DS
     D INFTXT                  1     34
     D INFLNK                 15     24
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for BANK details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** Currency Details
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for access programs
 
 
      ** File Information Data Structure for RE100612P1
     D SPOOL1          DS
     D  PSFile1               83     92
     D  PSFNum1              123    124B 0
 
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PLevel          S              1
     D PEnty           S              3
     D ZSnum           S              6  0
     D ZSerr           S              1
 
 
     I***ACPO1     NS                                                                         CAP204
     I***GLACPML0  NS                                                                CAP204 AR968075
     I**********                        1  400  INREC                                       AR968075
     IACPO1     NS                                                                          AR968075
     I                                  1  620  INREC                                       AR968075
 
     IRSACMTPO      01
     I              PTDT                        E_PSTD
     I              VUDT                        E_VALD
     I              NRTD                        E_PNAR
     I              MVAM                        E_PSTA
     I              DORC                        E_DRCR
     I              FUND                        E_OTRF
     I              XRFI                        E_XRFI
     I              XRFN                        E_XRFN
     IFFACMVDF      02
     I              PTDT                        E_PSTD
     I              VUDT                        E_VALD
     I              NRTD                        E_PNAR
     I              MVAM                        E_PSTA
     I              DORC                        E_DRCR
     I              OTRF                        E_OTRF
     I              XRFI                        E_XRFI
     I              XRFN                        E_XRFN
     I              NRTC                        ZZNRTC
     IAPOSTPDF      03
 
 
      * If end requested
      *  Call zero-balancing entry generation in 'end' mode
      *  Produce end of report
      *  Close files
      *  Do last return
 
     C     X_OPTN        IFEQ      '*END   '
     C     PgmEnded      IFNE      'Y'
     C                   EXSR      ZEROBAL_EG
     C                   EXSR      END_OF_REP
     C                   CLOSE     RE100612P1
     C     I_MODE        IFEQ      'I/C'
     C                   CLOSE     RSACMTL6
     C                   ELSE
     C**********         CLOSE     ACPO1                                                      CAP204
     C**********         CLOSE     GLACPML0                                          CAP204 AR968075
     C                   CLOSE     ACPO1                                                    AR968075
     C                   ENDIF
     C                   MOVEL     'Y'           PgmEnded          1
     C                   ENDIF
     C                   RETURN
     C                   ENDIF
 
      * Ignore this run code
 
     C                   MOVEL     *BLANK        IgnoreThisRun    15
     C                   EVAL      IgnoreThisRun = '*IGNORE' + I_MODE
     C                                             + I_SWP_TOP
 
      * Zeroize today's dr totals
 
     C                   Z-ADD     *zero         O_TVDR
     C                   Z-ADD     *zero         O_TCDR
 
      * If required, determine today's dr totals
 
     C                   MOVE      'N'           I_Max_Dr_Excd
     C     I_MODE        IFEQ      '1  '
     C     I_MODE        OREQ      '5  '
     C     I_MODE        OREQ      '1PC'                                        217028
     C     I_MODE        OREQ      '5PC'                                        217028
     C     I_MDVD        IFNE      *ZERO
     C     I_MDCD        ORNE      *ZERO
     C                   EXSR      DET_DR_TOTS
     C                   ENDIF
     C                   ENDIF
 
      * Source a/c ID ( = Child a/c ID)
 
     C                   MOVEL     I_CBRC        BRC
     C                   MOVEL     I_CCUS        CUS
     C                   MOVEL     I_CCCY        CCY
     C                   MOVEL     I_CACD        ACD
     C                   MOVEL     I_CASN        ASN
 
      * If new currency, access currency
 
     C     CCY           IFNE      L_CCY
     C                   MOVEL     CCY           L_CCY             3
     C                   EXSR      ACS_CURR
     C                   ENDIF
 
      * Zeroize count of entries processed
      * and initialize 'a/c reported' indicator
 
     C                   Z-ADD     0             CE                5 0
     C                   MOVEL     'N'           AC_Reported       1
 
      * If mode = new a/c associations, daily, or daily post capitalization
      *   Access opening ledger and cleared balance for child a/c
 
     C     I_MODE        IFEQ      'ASC'
     C     I_MODE        OREQ      '1  '
     C     I_MODE        OREQ      '1PC'
     C     GLACBLK       CHAIN     GLACBLF                            60        *
     C     *IN60         IFEQ      '0'
     C                   Z-ADD     LDBL          I_CLDBL
     C                   Z-ADD     CLBL          I_CCLBL
     C                   ENDIF
     C                   ENDIF
 
      * If this is the new a/c associations run of this function
      * and 'Sweep cleared balance on association date' = 'Y'
      * and the account's opening cleared balance <> 0
      *   Check if linked today
      *   If so, sweep the cleared balance value today
      *          and report the source account
 
     C                   MOVEL     'N'           CLBLSwept         1
     C     I_MODE        IFEQ      'ASC'
     C     I_SCBD        ANDEQ     'Y'
 
     C     I_CCLBL       IFNE      *ZERO
     C     I_SWP_TOP     ANDEQ     'B'
     C     I_CCLBL       ORLT      *ZERO
     C     I_SWP_TOP     ANDEQ     'S'
     C     I_CCLBL       ORGT      *ZERO
     C     I_SWP_TOP     ANDEQ     'T'
 
     C     RECMLCK       CHAIN     RECMLCL3                           60        *
     C     *IN60         IFEQ      '0'
     C                   EXSR      SWP_CLBL
     C     O_EntriesGen  IFEQ      'Y'
     C                   MOVEL     'Y'           CLBLSwept
     C                   EXSR      REP_SACCNT
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      * Read first child a/c entry
 
     C     I_MODE        IFEQ      'I/C'
     C     RSACMTK       SETLL     RSACMTL6
     C                   ELSE
     C*****ACPOK         SETLL     ACPO1                                                      CAP204
     C*****ACPOK         SETLL     GLACPML0                                          CAP204 AR968075
     C     ACPOK         SETLL     ACPO1                                                    AR968075
     C                   ENDIF
 
     C                   EXSR      READ_ENTRY
     C  N60              Z-ADD     E_VALD        VALD              5 0
      * Deferred posting must not zero balance                                  214360
     C  N60I_DEFP        COMP      'Y'                                    60    214360
      * Account associations on top account must not zero balance               216421
     C  N60I_MODE        IFEQ      'ASC'                                        216421
     C     I_CCAT        ANDEQ     'T'                                          216421
     C                   SETON                                            60    216421
     C                   ENDIF                                                  216421
 
 
      * Do until more more child a/c entries are read
 
     C     *IN60         DOWEQ     '0'
 
      * If the entry's value date is beyond the forward value date
      *   Write to the cash management exception file
 
     C     E_VALD        IFGT      I_FVDT
     C     BJDNWD        ANDGT     I_FVDT
     C                   EVAL      I_EXCP = 'ENTRY NOT ZERO BALANCED'
     C                   EVAL      I_REAS = 'VALUE DATE BEYOND FORWARD'
     C                                      + ' VALUE DATE'
     C                   EVAL      I_OREN = I_ENTRY
     C                   EXSR      WRT_CMX
     C                   ELSE                                                   216421
     C*******************ENDIF                                                  216421
 
      * If the entry's value date is before the back value date
      *   Write to the cash management exception file
 
     C     E_VALD        IFLT      I_BVDT
     C                   EVAL      I_EXCP = 'VALUE DATE OF ENTRY CHANGED'
     C                                      + ' FOR ZERO BALANCING'
     C                   EVAL      I_REAS = 'VALUE DATE PRIOR TO BACK'
     C                                      + ' VALUE DATE'
     C                   EVAL      I_OREN = I_ENTRY
     C                   EXSR      WRT_CMX
     C                   ENDIF
     C                   ENDIF                                                  216421
 
      * If the entry's value date is prior to
      * or equal to the event control date
      * and entry not to be ignored
      * or if its value date is prior to
      * or equal to the forward value date
      * and entry not to be ignored
 
     C     E_VALD        IFLE      I_EvtCtlDat
     C     E_OTRF        ANDNE     IgnoreEveryRun
     C     E_OTRF        ANDNE     IgnoreThisRun
     C     E_VALD        ORLE      I_FVDT
     C     E_OTRF        ANDNE     IgnoreEveryRun
     C     E_OTRF        ANDNE     IgnoreThisRun
 
      * If a/c not reported yet
      *  Report the source account
 
     C     AC_Reported   IFNE      'Y'
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
      * If the entry's value date is prior to the back value date
      *  its value date is set to the back value date
 
     C     E_VALD        IFLT      I_BVDT
     C                   Z-ADD     I_BVDT        E_VALD
     C                   Z-ADD     I_BVDT        VALD
     C                   ENDIF
 
      * On change of value date
      *  If top a/c zero balancing in COB, adjust totals for unmatched 101s     216421
      *  Do net or gross zero balancing entry generation
      *  Report date total
 
     C     E_VALD        IFNE      VALD
 
     C     I_CCAT        IFEQ      'T'                                          216421
     C                   IF        I_MODE = '1  ' OR I_MODE = '1PC'             216421
     C                             OR  I_MODE = '5  ' OR I_MODE = '5PC'         216421
     C                   EXSR      ADJ_UNM                                      216421
     C                   ENDIF                                                  216421
     C                   ENDIF                                                  216421
     C     I_ZBNG        IFEQ      'N'
     C                   EXSR      NET_EG
     C                   ELSE
     C                   EXSR      GROSS_EG
     C                   ENDIF
     C                   EXSR      REP_DATTOT
 
      * Next value date
 
     C                   Z-ADD     E_VALD        VALD
     C                   ENDIF
 
      * Accumulate value date, value date debit and value date credit totals
 
     C     E_DRCR        IFEQ      0
     C                   ADD       E_PSTA        NET_TOTAL
     C     E_PSTD        IFEQ      BJRDNB                                       212899
     C                   ADD       E_PSTA        DR_TOTAL
     C                   ENDIF                                                  212899
     C                   ELSE
     C                   SUB       E_PSTA        NET_TOTAL
     C     E_PSTD        IFEQ      BJRDNB                                       212899
     C                   SUB       E_PSTA        CR_TOTAL
     C                   ENDIF                                                  212899
     C                   ENDIF
 
      * Report Entry
 
     C                   EXSR      REP_ENTRY
 
      * Increment count of entries processed
 
     C                   ADD       1             CE
 
     C                   ENDIF
 
      * Read next child a/c entry
 
     C                   EXSR      READ_ENTRY
 
     C                   ENDDO
 
      * If entries processed
      *  If top a/c zero balancing in COB, adjust totals for unmatched 101s     216421
      *  Do net or gross zero balancing entry generation
      *  Report date total
 
     C     CE            IFNE      0
     C     I_CCAT        IFEQ      'T'                                          216421
     C                   IF        I_MODE = '1  ' OR I_MODE = '1PC'             216421
     C                             OR  I_MODE = '5  ' OR I_MODE = '5PC'         216421
     C                   EXSR      ADJ_UNM                                      216421
     C                   ENDIF                                                  216421
     C                   ENDIF                                                  216421
     C     I_ZBNG        IFEQ      'N'
     C                   EXSR      NET_EG
     C                   ELSE
     C                   EXSR      GROSS_EG
     C                   ENDIF
     C                   EXSR      REP_DATTOT
     C                   ENDIF
 
      * If the daily post run of this function
      * and a target balance is defined
      *  Do target balancing entry generation
      *  If a/c not reported yet
      *    Report the source account
      *  Report target balancing
      *  Increment count of entries processed
 
     C     I_MODE        IFEQ      '1  '
     C     I_MODE        OREQ      '1PC'                                        214360
     C*****I_CCAT********ANDEQ     'T'                                   214360 217028
 
     C     I_TGBL        IFNE      *ZERO
     C     I_SWP_TOP     ANDEQ     'B'
     C     I_TGBL        ORGT      *ZERO
     C     I_SWP_TOP     ANDEQ     'S'
     C     I_TGBL        ORLT      *ZERO
     C     I_SWP_TOP     ANDEQ     'T'
     C                   EXSR      TRGBAL_EG
     C     O_EntriesGen  IFEQ      'Y'
     C     AC_Reported   IFNE      'Y'
     C                   EXSR      REP_SACCNT
     C                   ENDIF
     C                   EXSR      REP_TRGBAL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      * If mode signifies that this is being run in input cycle
      * and a/c not reported yet
      *    Report the source account
 
     C     I_MODE        IFEQ      'I/C'
     C     AC_Reported   ANDNE     'Y'
     C                   EXSR      REP_SACCNT
     C                   ENDIF
 
 
     C                   RETURN
 
      /SPACE 5
      ********************************************************************
      * Read an entry
      ********************************************************************
     C     READ_ENTRY    BEGSR
 
     C     I_MODE        IFEQ      'I/C'
 
     C                   SETOFF                                       010203
     C     RSACMTK       READE     RSACMTL6                               60    *
     C  N03              Z-ADD     BJRDNB        E_PSTD                         212899
     C  N03              MOVEL     *BLANK        E_SPOS
     C  N03E_PNAR        IFEQ      *BLANK
     C                   EVAL      E_PNAR = E_TRYP + ' ' + E_TNMR
     C                   ENDIF
 
     C                   ELSE
 
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR968075
     C     ACPOK         READE     ACPO1                                  60    *           AR968075
     C  N60              MOVEL     INREC         I_ENTRY
     C     *IN60         DOWEQ     '0'
     C     E_RECI        ANDNE     'P'
     C     E_RECI        ANDNE     'D'
     C*****ACPOK         READE     ACPO1                                  60    *             CAP204
     C*****ACPOK         READE     GLACPML0                               60    *    CAP204 AR968075
     C     ACPOK         READE     ACPO1                                  60    *           AR968075
     C  N60              MOVEL     INREC         I_ENTRY
     C                   ENDDO
 
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Determine today's dr totals
      ********************************************************************
     C     DET_DR_TOTS   BEGSR
 
     C                   CALLB     'RE100616'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    I_MDVD           15 0
     C                   PARM                    I_MDCD            3 0
 
      * OUTPUTS
      * Maximum Debit Value/Debit Count in a Day Exceeded
     C                   PARM                    I_Max_Dr_Excd     1
      * Today's total dr value
      * Today's total dr count
     C                   PARM                    O_TVDR           15 0
     C                   PARM                    O_TCDR            3 0
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN DETERMINE DEBIT TOTALS'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Sweep the cleared balance value today
      ********************************************************************
     C     SWP_CLBL      BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     I_CCLBL       IFGT      0
     C                   Z-ADD     I_CCLBL       I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ELSE
     C                   Z-SUB     I_CCLBL       I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     BJRDNB        I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'ZERO BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'N'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'Y'           I_CBSA
 
      * Entry generation
     C                   EXSR      ZEROBAL_EG
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Net zero balancing entry generation
      ********************************************************************
     C     NET_EG        BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     NET_TOTAL     IFGT      0
     C                   Z-ADD     NET_TOTAL     I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ELSE
     C                   Z-SUB     NET_TOTAL     I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     VALD          I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'ZERO BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'N'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'N'           I_CBSA
 
      * Entry generation
     C     NET_TOTAL     IFNE      0
     C                   EXSR      ZEROBAL_EG
     C                   MOVEL     O_EntriesGen  NET_EntriesGen
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Gross zero balancing entry generation
      ********************************************************************
     C     GROSS_EG      BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C                   Z-ADD     DR_TOTAL      I_PSTA
     C                   MOVEL     'C'           I_CADC
 
      * Value date
     C                   Z-ADD     VALD          I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'ZERO BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'N'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'N'           I_CBSA
 
      * Entry generation
     C                   Z-SUB     CR_TOTAL      W_PSTA           13 0
     C     DR_TOTAL      IFNE      0
     C     DR_TOTAL      ANDNE     W_PSTA
     C                   EXSR      ZEROBAL_EG
     C                   MOVEL     O_EntriesGen  DR_EntriesGen
     C                   ENDIF
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C                   Z-SUB     CR_TOTAL      I_PSTA
     C                   MOVEL     'D'           I_CADC
 
      * Value date
     C                   Z-ADD     VALD          I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'ZERO BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'N'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'N'           I_CBSA
 
      * Entry generation
     C                   Z-SUB     DR_TOTAL      W_PSTA           13 0
     C     CR_TOTAL      IFNE      0
     C     CR_TOTAL      ANDNE     W_PSTA
     C                   EXSR      ZEROBAL_EG
     C                   MOVEL     O_EntriesGen  CR_EntriesGen
     C                   ENDIF
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Target balancing entry generation
      ********************************************************************
     C     TRGBAL_EG     BEGSR
 
      * Posting Amount
      * Child A/c Debit/Credit ind
 
     C     I_TGBL        IFGT      0
     C                   Z-ADD     I_TGBL        I_PSTA
     C                   MOVEL     'D'           I_CADC
     C                   ELSE
     C                   Z-SUB     I_TGBL        I_PSTA
     C                   MOVEL     'C'           I_CADC
     C                   ENDIF
 
      * Value date
     C                   Z-ADD     BJDNWD        I_VALD
 
      * Sweep Description
     C                   EVAL      I_SDES = 'TARGET BALANCE'
 
      * Sweep Type
     C                   MOVEL     'Z'           I_STYP
 
      * Target Balance
     C                   MOVEL     'Y'           I_TBAL
 
      * Cleared Bal Sweep on Assoc Date
     C                   MOVEL     'N'           I_CBSA
 
      * Entry generation
     C                   EXSR      ZEROBAL_EG
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Zero balancing entry generation
      ********************************************************************
     C     ZEROBAL_EG    BEGSR
 
     C                   CALLB     'RE100608'
 
      * Return code
      * Error Message
      * Option
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM                    I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_BRCA            3            213569
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD                                       CGL029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CANM           20
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child a/c status
     C                   PARM                    I_ChildSTAT      26
      * Level
     C                   PARM                    I_LEVL            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD                                       CGL029
     C                   PARM                    I_PASN            2 0
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    I_PRNO           10 0
     C                   PARM                    I_PANM           20
     C                   PARM                    I_PPRF            4
     C                   PARM                    I_PACS            2
     C                   PARM                    I_PATY            1
      * Parent a/c status
     C                   PARM                    I_ParentSTAT     26
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM                    I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM                    I_SWP_TOP         1
      * Sweeping Holiday Convention                                             213196
     C                   PARM                    I_SHOC            1            213196
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM                    I_FLFT           15 0
     C                   PARM                    I_FLFS           15 0
     C                   PARM                    I_TYPT            5
     C                   PARM                    I_TYPS            5
 
      * Maximum Debit Value/Debit Count in a Day Exceeded
     C                   PARM                    I_Max_Dr_Excd     1
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_DEST           18
     C                   PARM                    I_DSTT            1
     C                   PARM                    I_SNDC            2
     C                   PARM                    I_RCVC           11
     C                   PARM                    I_MCMR            1
     C                   PARM                    I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM                    I_CHG1            3
     C**********         PARM                    I_CAC1           18                          CGL029
     C                   PARM                    I_CAC1           24                          CGL029
     C                   PARM                    I_CAM1           15 0
     C                   PARM                    I_ICD1            4
     C                   PARM                    I_CHG3            3
     C**********         PARM                    I_CAC3           18                          CGL029
     C                   PARM                    I_CAC3           24                          CGL029
     C                   PARM                    I_CAM3           15 0
     C                   PARM                    I_ICD3            4
     C                   PARM                    I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM                    I_EXA1           35
     C                   PARM                    I_EXA2           35
     C                   PARM                    I_EXA3           35
     C                   PARM                    I_EXA4           35
     C                   PARM                    I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting                                                        216421
      * Deferred Posting Zero Narrative                                         216421
     C                   PARM                    I_TAST            1            214360
     C                   PARM                    I_DEFP            1            216421
     C                   PARM                    I_DEFZ            1            216421
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Posting amount
      * Child A/c Debit/Credit ind
      * Value date
      * Sweep Description
      * Sweep Type     (Z or S)
      * Target Balance (Y or N)
      * Cleared Bal Sweep on Assoc Date (Y or N)
      * Zero Balancing Net or Gross (N or G)
     C                   PARM                    I_PSTA           13 0
     C                   PARM                    I_CADC            1
     C                   PARM                    I_VALD            5 0
     C                   PARM                    I_SDES           30
     C                   PARM                    I_STYP            1
     C                   PARM                    I_TBAL            1
     C                   PARM                    I_CBSA            1
     C                   PARM                    I_ZBNG            1
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
      * Entries generated
     C                   PARM                    O_EntriesGen      1
 
      * End if error occurred in module
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN ENTRY GENERATION'
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                214360
     C     O_EntriesGen  IFEQ      'Y'                                          214360
     C                   MOVEL     'Y'           O_Entries                      214360
     C                   ENDIF                                                  214360
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Write to the cash management exception file
      ********************************************************************
     C     WRT_CMX       BEGSR
 
     C                   CALLB     'REWRTCMX'
 
      * Return code
      * Error Message
     C                   PARM      *BLANK        X_RTCD
     C                   PARM      *BLANK        X_ERMS
 
      * INPUTS
      * Hierarchy ID
      * Hierarchy Shortname
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Exception
      * Reason
     C                   PARM                    I_EXCP           60
     C                   PARM                    I_REAS           60
      * Zero Balancing/Sweeping Entry
      * Original Entry
     C                   PARM      *BLANK        I_ZSEN           60
     C                   PARM                    I_OREN          330
      * Mode
      * Time
     C                   PARM                    I_MODE            3
     C                   PARM                    I_TIME            6
 
     C     X_RTCD        IFEQ      '*ERROR'
     C                   EVAL      X_ERMS = 'ERROR IN WRITE TO RECMEXPD'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      ********************************************************************
      /SPACE 5                                                                  216421
      ********************************************************************      216421
      * Adjust totals for unmatched 101s                                        216421
      ********************************************************************      216421
     C     ADJ_UNM       BEGSR                                                  216421
                                                                                216421
      * Read all unmatched 101s for hierarchy                                   216421
                                                                                216421
     C     I_HIER        SETLL     REICSDL6                                     216421
     C     I_HIER        READE     REICSDL6                               60    216421
     C                                                                          216421
     C     *IN60         DOWEQ     *OFF                                         216421
                                                                                216421
      * Read all items                                                          216421
                                                                                216421
     C     ICZBK         SETLL     REICSIL0                                     216421
     C     ICZBK         READE     REICSIL0                               60    216421
     C                                                                          216421
     C     *IN60         DOWEQ     *OFF                                         216421
                                                                                216421
      * For each item, access the posting                                       216421
      * If it is to the top a/c and produced today, value today                 216421
      * accumulate the posting amount and report the unmatched entry            216421
                                                                                216421
     C     POSTK         CHAIN     GLPSTTD0                           60        216421
     C     *IN60         IFEQ      *ON                                          216421
     C                   MOVE      I_IIXRFN      WERMS            10            216421
     C                   EVAL      X_ERMS = 'No GLPSTTPD for ' + %TRIML(WERMS)  216421
     C                   EXSR      *PSSR                                        216421
     C                   ENDIF                                                  216421
     C     U_BRCA        IFEQ      I_CBRC                                       216421
     C     U_CNUM        ANDEQ     I_CCUS                                       216421
     C     U_CCY         ANDEQ     I_CCCY                                       216421
     C     U_ACOD        ANDEQ     I_CACD                                       216421
     C     U_ACSQ        ANDEQ     I_CASN                                       216421
     C     U_PSTD        ANDEQ     BJRDNB                                       216421
     C     U_VALD        ANDLE     I_EvtCtlDat                                  216421
     C     U_OTRF        ANDNE     IgnoreEveryRun                               212904
     C     U_OTRF        ANDNE     IgnoreThisRun                                212904
      * Accumulate                                                              216421
     C     U_DRCR        IFEQ      0                                            216421
     C                   ADD       U_PSTA        NET_TOTAL                      216421
     C                   ADD       U_PSTA        DR_TOTAL                       216421
     C                   ELSE                                                   216421
     C                   SUB       U_PSTA        NET_TOTAL                      216421
     C                   SUB       U_PSTA        CR_TOTAL                       216421
     C                   ENDIF                                                  216421
      * Report Unmatched Entry                                                  216421
     C                   EXSR      REP_UNM_ENTRY                                216421
     C                   ENDIF                                                  216421
     C                                                                          216421
     C     ICZBK         READE     REICSIL0                               60    216421
     C                   ENDDO                                                  216421
     C     I_HIER        READE     REICSDL6                               60    216421
     C                   ENDDO                                                  216421
                                                                                216421
     C                   ENDSR                                                  216421
      ********************************************************************      216421
      /SPACE 5
      ********************************************************************
      * Report the source account
      ********************************************************************
     C     REP_SACCNT    BEGSR
 
      * Show retail a/c numbers
 
     C     I_CRNO        COMP      0                                  3535      *
 
      * Edit ledger balance
      * and  ledger balance dr/cr indicator
 
     C     I_CLDBL       IFGT      0
     C                   Z-ADD     I_CLDBL       w_AMT            15 0
     C                   MOVEL     'DR'          R_LDRCR
     C                   ELSE
     C                   Z-SUB     I_CLDBL       w_AMT
     C                   MOVEL     'CR'          R_LDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_LDBL
 
      * Edit cleared balance
      * and  cleared balance dr/cr indicator
 
     C     I_CCLBL       IFGT      0
     C                   Z-ADD     I_CCLBL       w_AMT
     C                   MOVEL     'DR'          R_CDRCR
     C                   ELSE
     C                   Z-SUB     I_CCLBL       w_AMT
     C                   MOVEL     'CR'          R_CDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_CLBL
 
     C     CLBLSwept     COMP      'Y'                                    40    *
 
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     SOURCE
 
     C                   MOVEL     'Y'           AC_Reported
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report entry
      ********************************************************************
     C     REP_ENTRY     BEGSR
 
      * Edit information text
 
     C     E_XRFI        IFEQ      'ZS '
     C                   MOVEL     E_OTST        INFLNK
     C                   ELSE
     C                   MOVEL     *BLANK        INFLNK
     C                   ENDIF
 
      * Edit value date of entry
 
     C                   Z-ADD     E_VALD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_VALD
 
      * Edit posting amount of entry
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      E_PSTA        ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_PSTA
 
      * Edit posting dr/cr indicator
 
     C     E_DRCR        IFEQ      0
     C                   MOVEL     'DR'          R_DRCR
     C                   ELSE
     C                   MOVEL     'CR'          R_DRCR
     C                   ENDIF
                                                                                216421
      * Posting narrative                                                       216421
      * Source of posting                                                       216421
     C                   MOVEL     E_PNAR        R_PNAR                         216421
     C                   MOVEL     E_SPOS        R_SPOS                         216421
 
     C                   Z-ADD     1             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     ENTRY
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5                                                                  216421
      ********************************************************************      216421
      * Report unmatched entry                                                  216421
      ********************************************************************      216421
     C     REP_UNM_ENTRY BEGSR                                                  216421
                                                                                216421
      * Edit information text                                                   216421
                                                                                216421
     C                   MOVEL     *BLANK        INFLNK                         216421
     C                   MOVEL     'UNMATCHED'   INFLNK                         216421
                                                                                216421
      * Edit value date of entry                                                216421
                                                                                216421
     C                   Z-ADD     U_VALD        ZDAYNO                         216421
     C                   EXSR      ZDATE2                                       216421
     C                   MOVEL     ZADATE        R_VALD                         216421
                                                                                216421
      * Edit posting amount of entry                                            216421
                                                                                216421
     C                   MOVE      *ZERO         ZFIELD                         216421
     C                   MOVE      U_PSTA        ZFIELD                         216421
     C                   EXSR      ZEDIT                                        216421
     C                   MOVE      ZFIELD        R_PSTA                         216421
                                                                                216421
      * Edit posting dr/cr indicator                                            216421
                                                                                216421
     C     U_DRCR        IFEQ      0                                            216421
     C                   MOVEL     'DR'          R_DRCR                         216421
     C                   ELSE                                                   216421
     C                   MOVEL     'CR'          R_DRCR                         216421
     C                   ENDIF                                                  216421
                                                                                216421
      * Posting narrative                                                       216421
      * Source of posting                                                       216421
     C                   MOVEL     U_PNAR        R_PNAR                         216421
     C                   MOVEL     U_SPOS        R_SPOS                         216421
                                                                                216421
     C                   Z-ADD     1             CHLINE            3 0          216421
     C                   EXSR      PAG                                          216421
     C                   WRITE     ENTRY                                        216421
                                                                                216421
     C                   ENDSR                                                  216421
      *******************************************************************       216421
      /SPACE 5
      ********************************************************************
      * Report date total
      ********************************************************************
     C     REP_DATTOT    BEGSR
 
      * NET
 
     C     I_ZBNG        IFEQ      'N'
 
      * Edit posting total
      * and  posting total dr/cr indicator
 
     C     NET_TOTAL     IFGT      0
     C                   Z-ADD     NET_TOTAL     w_AMT
     C                   MOVEL     'CR'          R_TDC
     C                   ELSE
     C                   Z-SUB     NET_TOTAL     w_AMT
     C                   MOVEL     'DR'          R_TDC
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_TOT
 
     C                   Z-ADD     3             CHLINE            3 0
     C                   EXSR      PAG
     C     NET_EntriesGenCOMP      'Y'                                    45
     C                   WRITE     NDATTOT
 
     C                   ELSE
      * GROSS
 
      * Edit debit posting total
      * and  debit posting total dr/cr indicator
 
     C                   Z-ADD     DR_TOTAL      w_AMT
     C                   MOVEL     'CR'          R_DRTDC
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_DRTOT
 
      * Edit credit posting total
      * and  credit posting total dr/cr indicator
 
     C                   Z-SUB     CR_TOTAL      w_AMT
     C                   MOVEL     'DR'          R_CRTDC
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_CRTOT
 
     C                   Z-ADD     4             CHLINE            3 0
     C                   EXSR      PAG
     C     CR_EntriesGen COMP      'Y'                                    45
     C     DR_EntriesGen COMP      'Y'                                    46
     C                   WRITE     GDATTOT
 
     C                   ENDIF
 
      * Zeroize totals
 
     C                   Z-ADD     *ZERO         NET_TOTAL        15 0
     C                   Z-ADD     *ZERO         DR_TOTAL         15 0
     C                   Z-ADD     *ZERO         CR_TOTAL         15 0
 
      * Initialize entries generated indicators
 
     C                   MOVEL     'N'           NET_EntriesGen    1
     C                   MOVEL     'N'           DR_EntriesGen     1
     C                   MOVEL     'N'           CR_EntriesGen     1
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Report target balance
      ********************************************************************
     C     REP_TRGBAL    BEGSR
 
      * Edit target balance
      * and  target balance dr/cr indicator
 
     C     I_TGBL        IFGT      0
     C                   Z-ADD     I_TGBL        w_AMT            15 0
     C                   MOVEL     'DR'          R_TDRCR
     C                   ELSE
     C                   Z-SUB     I_TGBL        w_AMT
     C                   MOVEL     'CR'          R_TDRCR
     C                   ENDIF
 
     C                   MOVE      *ZERO         ZFIELD
     C                   MOVE      w_AMT         ZFIELD
     C                   EXSR      ZEDIT
     C                   MOVE      ZFIELD        R_TGBL
 
     C                   Z-ADD     2             CHLINE            3 0
     C                   EXSR      PAG
     C                   WRITE     TRGBAL
 
     C                   ENDSR
      *******************************************************************
     C/SPACE 5
      ********************************************************************
      * End of Report
      ********************************************************************
     C     END_OF_REP    BEGSR
 
      * Output 'end of report'
 
     C                   Z-ADD     3             CHLINE
     C                   EXSR      PAG
     C                   WRITE     ENDOFREP
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * Throw page headings (if required)
      ********************************************************************
     C     PAG           BEGSR
 
      * Set time
     C                   TIME                    R_TIME
 
     C                   ADD       CHLINE        LINENO
     C     LINENO        IFGT      59
     C                   ADD       1             PAGNUM
     C                   WRITE     PAGEHEAD
     C     6             ADD       CHLINE        LINENO            3 0
     C                   ENDIF
 
     C                   ENDSR
     C********************************************************************
      /SPACE 5
      ********************************************************************
      * Access a currency
      ********************************************************************
     C     ACS_CURR      BEGSR
 
     C                   CALLB     'ZAACSCURR'
     C                   PARM                    CCY               3
     C                   PARM                    SDCURR
 
      * Database error if currency not found
 
     C     A6CYCD        IFEQ      *BLANK
     C                   EVAL      X_ERMS = 'BAD CCY CODE:' + CCY
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Convert a day number into a date
      ********************************************************************
     C     ZDATE2        BEGSR
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      'M'           ZDFIN             1
     C                   PARM      *ZERO         ZDATEN            6 0
     C                   PARM      *BLANK        ZADATE            7
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Edit an amount
      ********************************************************************
     C     ZEDIT         BEGSR
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM      A6NBDP        ZADEC             1 0
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * Register P1 printer file with RCF
      ********************************************************************
     C     RCFP1         BEGSR
 
     C                   EVAL      ZSnum = PSFNum1
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEnty
     C                   PARM                    PSFile1
     C                   PARM                    ZSnum
     C                   PARM      *Blank        ZSErr
 
      ** If Error occurs during ZSFILE processing, then end abnormally
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      X_ERMS = 'Call to ZSFILE in error'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * *INZSR --- INITIAL PROCESSING
      ********************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      * Return code
      * Error Message
      * Option
     C                   PARM                    X_RTCD
     C                   PARM                    X_ERMS
     C                   PARM                    X_OPTN
 
      * INPUTS
      * Mode
     C                   PARM                    I_MODE            3
      * Time
     C                   PARM                    I_TIME            6
      * Hierarchy ID
      * Hierarchy Shortname
      * Hierarchy Branch                                                        213569
     C                   PARM                    I_HIER            9 0
     C                   PARM                    I_HISN           10
     C                   PARM                    I_BRCA            3            213569
      * Link ID
     C                   PARM                    I_LINK            9 0
      * Child branch
      * Child customer
      * Child currency
      * Child a/c code
      * Child a/c seq.
     C                   PARM                    I_CBRC            3
     C**********         PARM                    I_CCUS            6 0                        CSD027
     C                   PARM                    I_CCUS            6                          CSD027
     C                   PARM                    I_CCCY            3
     C**********         PARM                    I_CACD            4 0                        CGL029
     C                   PARM                    I_CACD                                       CGl029
     C                   PARM                    I_CASN            2 0
      * Child A/c Category
     C                   PARM                    I_CCAT            1
      * Child retail no.
      * Child a/c name
      * Child a/c profit centre
      * Child a/c account section
     C                   PARM                    I_CRNO           10 0
     C                   PARM                    I_CANM           20
     C                   PARM                    I_CPRF            4
     C                   PARM                    I_CACS            2
      * Child a/c status
     C                   PARM                    I_ChildSTAT      26
      * Child Ledger Balance
      * Child Cleared Balance
     C                   PARM                    I_CLDBL          15 0
     C                   PARM                    I_CCLBL          15 0
      * Level
     C                   PARM                    I_LEVL            2 0
      * Parent branch
      * Parent customer
      * Parent currency
      * Parent a/c code
      * Parent a/c seq.
     C                   PARM                    I_PBRC            3
     C**********         PARM                    I_PCUS            6 0                        CSD027
     C                   PARM                    I_PCUS            6                          CSD027
     C                   PARM                    I_PCCY            3
     C**********         PARM                    I_PACD            4 0                        CGL029
     C                   PARM                    I_PACD                                       CGL029
     C                   PARM                    I_PASN            2 0
      * Parent retail no.
      * Parent a/c name
      * Parent a/c profit centre
      * Parent a/c account section
      * Parent a/c account type
     C                   PARM                    I_PRNO           10 0
     C                   PARM                    I_PANM           20
     C                   PARM                    I_PPRF            4
     C                   PARM                    I_PACS            2
     C                   PARM                    I_PATY            1
      * Parent a/c status
     C                   PARM                    I_ParentSTAT     26
      * Child Account Narrative
      * Parent Account Narrative
     C                   PARM                    I_CNAR           30
     C                   PARM                    I_PNAR           30
      * Sweep/Top
     C                   PARM                    I_SWP_TOP         1
 
      * Forward value date
      * Back value date
     C                   PARM                    I_FVDT            5 0
     C                   PARM                    I_BVDT            5 0
 
      * Sweep capitalized interest
      * Sweep cleared balance on associaton date
      * Zero Balance - Net or Gross
      * Target balance
     C                   PARM                    I_SCPI            1
     C                   PARM                    I_SCBD            1
     C                   PARM                    I_ZBNG            1
     C                   PARM                    I_TGBL           15 0
      * Sweeping Holiday Convention                                             213196
     C                   PARM                    I_SHOC            1            213196
 
      * Floor Limit for Top
      * Floor Limit for Sweep
      * Transaction Type - Top
      * Transaction Type - Sweep
     C                   PARM                    I_FLFT           15 0
     C                   PARM                    I_FLFS           15 0
     C                   PARM                    I_TYPT            5
     C                   PARM                    I_TYPS            5
 
      * Maximum Debit Value in a Day
      * Maximum Debit Count in a Day
     C                   PARM                    I_MDVD           15 0
     C                   PARM                    I_MDCD            3 0
      * Destination
      * Destination Type
      * Sender's Correspondent
      * Receiver's Correspondent
      * MT202 Cover Message Required
      * MT103 Value Date Offset
     C                   PARM                    I_DEST           18
     C                   PARM                    I_DSTT            1
     C                   PARM                    I_SNDC            2
     C                   PARM                    I_RCVC           11
     C                   PARM                    I_MCMR            1
     C                   PARM                    I_MVDO            1
      * MT101 Charges
      * MT101 Charges Account
      * MT101 Charges Amount
      * MT101 Instruction Code
      * MT103 Charges
      * MT103 Charges Account
      * MT103 Charges Amount
      * MT103 Instruction Code
      * MT103 Bank Operation Code
     C                   PARM                    I_CHG1            3
     C**********         PARM                    I_CAC1           18                          CGL029
     C                   PARM                    I_CAC1                                       CGL029
     C                   PARM                    I_CAM1           15 0
     C                   PARM                    I_ICD1            4
     C                   PARM                    I_CHG3            3
     C**********         PARM                    I_CAC3           18                          CGL029
     C                   PARM                    I_CAC3                                       CGL029
     C                   PARM                    I_CAM3           15 0
     C                   PARM                    I_ICD3            4
     C                   PARM                    I_BOCD            4
      * External Account 1
      * External Account 2
      * External Account 3
      * External Account 4
      * External Account 5
     C                   PARM                    I_EXA1           35
     C                   PARM                    I_EXA2           35
     C                   PARM                    I_EXA3           35
     C                   PARM                    I_EXA4           35
     C                   PARM                    I_EXA5           35
      * Top a/c Sweep Type                                                      214360
      * Deferred Posting                                                        214360
      * Deferred Posting Zero Narrative                                         214360
     C                   PARM                    I_TAST            1            214360
     C                   PARM                    I_DEFP            1            214360
     C                   PARM                    I_DEFZ            1            214360
      * Next Available Seq No.
     C                   PARM                    I_NASN            2 0
      * Top a/c balance
      * Top a/c overdraft
     C                   PARM                    I_TopBalance     15 0
     C                   PARM                    I_TopOverDft     15 0
 
      * Event Control date
     C                   PARM                    I_EvtCtlDat       5 0
 
      * OUTPUTS
      * Today's total dr value
      * Today's total dr count
     C                   PARM                    O_TVDR           15 0
     C                   PARM                    O_TCDR            3 0
      * Entries Y/N                                                             214360
     C                   PARM                    O_Entries         1            214360
 
      *  Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR  '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
 
      * Edited Date of Next Working Day
 
     C                   Z-ADD     BJDNWD        ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        R_DNWD
 
      **Day*prior*to*date*of*next*working*day****                               216421
      *******************************************                               216421
     C******JDNWD********SUB*******1*************DateNWDS1         5 0          216421
 
      * Throw a page
 
     C                   Z-ADD     99            LINENO
 
      * Open files
     C                   OPEN      RE100612P1
     C     I_MODE        IFEQ      'I/C'
     C                   OPEN      RSACMTL6
     C                   ELSE
     C**********         OPEN      ACPO1                                                      CAP204
     C**********         OPEN      GLACPML0                                          CAP204 AR968075
     C                   OPEN      ACPO1                                                    AR968075
     C                   ENDIF
 
      * Register P1 printer file with RCF
     C                   EXSR      RCFP1
 
      * Set mode narrative printed on report
 
     C                   SELECT
     C     I_MODE        WHENEQ    'ASC'
     C                   MOVEL     #_INF(1)      MODENARR
     C     I_MODE        WHENEQ    '1  '
     C                   MOVEL     #_INF(2)      MODENARR
     C     I_MODE        WHENEQ    '1PC'
     C                   MOVEL     #_INF(3)      MODENARR
     C     I_MODE        WHENEQ    '5  '
     C                   MOVEL     #_INF(4)      MODENARR
     C     I_MODE        WHENEQ    '5PC'
     C                   MOVEL     #_INF(5)      MODENARR
     C     I_MODE        WHENEQ    'I/C'
     C                   MOVEL     #_INF(6)      MODENARR
     C                   ENDSL
 
      * Set requested time
     C                   MOVEL     I_TIME        R_RTIME
 
      * Ignore every run code
 
     C                   MOVEL     *BLANK        IgnoreEveryRun   15
     C                   EVAL      IgnoreEveryRun = '*IGNORE'
                                                                                216421
     C                   MOVEL     'ZS '         ZSRFI             3            216421
 
      * Key lists
 
     C     GLACBLK       KLIST
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C                   KFLD                    BRC
     C     RSACMTK       KLIST
     C                   KFLD                    BRC
     C                   KFLD                    CUS
     C                   KFLD                    CCY
     C                   KFLD                    ACD
     C                   KFLD                    ASN
     C     RECMLCK       KLIST
     C                   KFLD                    I_HIER
     C                   KFLD                    I_CBRC
     C                   KFLD                    I_CCUS
     C                   KFLD                    I_CCCY
     C                   KFLD                    I_CACD
     C                   KFLD                    I_CASN
     C     ICZBK         KLIST                                                  216421
     C                   KFLD                    D_IDHIER                       216421
     C                   KFLD                    D_IDLINK                       216421
     C                   KFLD                    D_IDPRCD                       216421
     C                   KFLD                    D_IDSNUM                       216421
     C     POSTK         KLIST                                                  216421
     C                   KFLD                    ZSRFI                          216421
     C                   KFLD                    I_IIXRFN                       216421
 
     C                   ENDSR
      *******************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY ZACPYSRC,RECMPSSR
      *****************************************************************
** #_INF
* NEW ACCOUNT ASSOCIATIONS *
* DAILY *
* DAILY - POST CAPITALIZATION *
* ANWD *
* ANWD - POST CAPITALIZATION *
* INPUT CYCLE *